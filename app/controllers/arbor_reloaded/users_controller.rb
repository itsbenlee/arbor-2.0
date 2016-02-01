module ArborReloaded
  class UsersController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

    def show
    end

    def update
      unless current_user.update_attributes(user_params)
        flash[:alert] = current_user.errors.full_messages.to_sentence
      end
      redirect_to arbor_reloaded_user_path(current_user)
    end

    private

    def user_params
      params.require(:user).permit(:full_name, :email, :avatar)
    end
  end
end
