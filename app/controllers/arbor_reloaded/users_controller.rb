module ArborReloaded
  class UsersController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

    def show
    end

    def read_updates
      session[:dismiss_updates] = 1

      head :no_content
    end
  end
end
