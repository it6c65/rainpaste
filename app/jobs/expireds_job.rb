class ExpiredsJob
  include SuckerPunch::Job

  def perform(paste_id)
    ActiveRecord::Base.connection_pool.with_connection do
      paste = Paste.find(paste_id)
      if paste.expired_at < Time.current
        paste.destroy
      end
    end
  end
end

Paste.all.each do |paste|
  ExpiredsJob.perform_async(paste.id)
  SuckerPunch.logger = Logger.new('sucker_punch.log')
  SuckerPunch.logger
end
