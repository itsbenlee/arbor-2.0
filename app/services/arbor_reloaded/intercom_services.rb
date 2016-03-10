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
      @intercom.events.create(event_name: 'created project',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def user_story_create_event
      @intercom.events.create(event_name: 'created user story',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def criterion_create_event
      @intercom.events.create(event_name: 'created acceptance criteria',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def comment_create_event
      @intercom.events.create(event_name: 'created comment',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def export_to_trello_event
      @intercom.events.create(event_name: 'exported to trello',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def export_to_pdf_event
      @intercom.events.create(event_name: 'exported to pdf',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def connect_to_slack_event
      @intercom.events.create(event_name: 'connected to slack',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def favorite_project_event
      @intercom.events.create(event_name: 'favorited project',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end

    def estimate_story_event
      @intercom.events.create(event_name: 'estimated story',
                              created_at: Time.now.to_i,
                              email: @user.email)
    end
  end
end
