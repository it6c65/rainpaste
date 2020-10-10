class PastesController < ApplicationController
  before_action :set_paste, only: [:edit, :update, :destroy]
  skip_before_action :require_login, only: [:new,:create, :show]

  # GET /pastes
  # GET /pastes.json
  def index
    @pastes = Paste.all
    @pastes.each do |paste|
      # Task to all deleted notes
      ExpiredsJob.perform_async(paste.id)
    end
  end

  # GET /pastes/:hashcode
  def show
    @paste = Paste.find_by(hashnote: params[:hashnote])
    unless current_user
      if @paste.nil?
        flash[:notice] = "Paste has been deleted!"
        redirect_to root_path
      else
        # Task to deleted notes the current paste
        ExpiredsJob.new.perform(@paste.id)
      end
    end
  end

  # GET /pastes/new
  def new
    @paste = Paste.new
  end

  # GET /pastes/1/edit
  def edit
  end

  # POST /pastes
  # POST /pastes.json
  def create
    @paste = Paste.new(paste_params)

    respond_to do |format|
      if @paste.save
        unless current_user
          format.html { redirect_to hashpublic_path(@paste.hashnote), notice: 'Paste was successfully created.' }
        else
          format.html { redirect_to root_path , notice: 'Paste was successfully created.' }
        end
        format.json { render :show, status: :created, location: @paste }
      else
        format.html { render :new }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pastes/1
  # PATCH/PUT /pastes/1.json
  def update
    respond_to do |format|
      if @paste.update(paste_params)
        format.html { redirect_to @paste, notice: 'Paste was successfully updated.' }
        format.json { render :show, status: :ok, location: @paste }
      else
        format.html { render :edit }
        format.json { render json: @paste.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pastes/1
  # DELETE /pastes/1.json
  def destroy
    @paste.destroy
    respond_to do |format|
      format.html { redirect_to pastes_url, notice: 'Paste was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_paste
      begin
      @paste = Paste.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        redirect_to pastes_url, notice: 'Paste has been deleted!'
      end
    end

    # Only allow a list of trusted parameters through.
    def paste_params
      params[:paste][:expired_at] = params[:paste][:expired_at].to_i.minutes.from_now
      params[:paste][:hashnote] = Digest::SHA1.hexdigest params[:paste][:content]
      params.require(:paste).permit(:title,:content,:language,:expired_at,:hashnote)
    end
end
