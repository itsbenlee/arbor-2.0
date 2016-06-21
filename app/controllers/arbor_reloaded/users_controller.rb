module ArborReloaded
  class UsersController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

    def show
    end
  end
end
