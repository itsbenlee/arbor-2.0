module ArborReloaded
  class JiraController < ApplicationController
    skip_before_action :current_user_projects

    def create
      response = service.start_authentication(
        "#{request.base_url}/authenticate" # TODO
      )

      session[:request_token] = response[:token]
      session[:request_secret] = response[:secret]

      @login_url = response[:url]
      @errors = response[:errors] || [] # TODO: resoponse never contains errors
    end

    def authenticate
      access_token = service.authenticate(params[:oauth_verifier])

      session[:jira_auth] = {
        access_token: access_token.token,
        access_key: access_token.secret
      }

      session.delete(:request_token)
      session.delete(:request_secret)

      redirect_to root_path
    end

    private

    def service
      ArborReloaded::JiraServices.new(
        session[:request_token], session[:request_secret]
      )
    end
  end
end
