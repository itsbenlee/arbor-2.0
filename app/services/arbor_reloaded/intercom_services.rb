module ArborReloaded
  class IntercomServices
    def initialize(current_user)
      @intercom = Intercom::Client.new(app_id: ENV['INTERCOM_APP_ID'],
                                       api_key: ENV['INTERCOM_API_KEY'])
      @user = current_user
    end

    def user_create_event
      @intercom.users.create(email: @user.email,
                             name: @user.full_name,
                             signed_up_at: Time.now.to_i)
    end

    def project_create_event
      @intercom.events.create(
        event_name: 'created-project', created_at: Time.now.to_i,
        email: @user.email
      )
    end
  end
end
