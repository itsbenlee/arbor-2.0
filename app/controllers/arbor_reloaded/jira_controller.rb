module ArborReloaded
  class JiraController < ApplicationController
    skip_before_action :current_user_projects

    def authenticate
      @response = ArborReloaded::JiraServices.new.authenticate(
        params[:email], params[:password], params[:site])
    end
  end
end
