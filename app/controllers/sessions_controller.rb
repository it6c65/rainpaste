class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def create
    @user = login(params[:email],params[:password])
    if @user
      redirect_back_or_to(root_path, notice: "login successful")
    else
      flash.now[:alert] = "Login failed"
      render action: "new"
    end
  end

  def new
  end

  def destroy
    logout
    redirect_to(root_path, notice: "logged out")
  end
end
