module ArborReloaded
  class IntercomServices
    def initialize(current_user)
      if ENV['ENABLE_INTERCOM'] == 'true'
        @intercom = Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'],
                                         api_key: ENV['INTERCOM_API_KEY'])
        @user = current_user
      else
        @intercom = nil
      end
    end

    def user_create_event
      return unless @intercom
      @intercom.users.create(email: @user.email,
                             name: @user.full_name,
                             signed_up_at: Time.now.to_i)
    end

    def create_event(event_key)
      return unless @intercom
      @intercom.events.create(event_name: event_key,
                              created_at: Time.now.to_i,
                              email: @user.email)
    rescue Intercom::ResourceNotFound
      user_create_event
    end
  end
end
