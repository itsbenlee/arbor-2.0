module ArborReloaded
  class UsersController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!
    before_action :check_edit_permission, only: [:update]

    def show
    end

    def update
      user = User.find(user_params[:id])
      user.update_attributes(user_params)
      json_update(user)
    end

    private

    def check_edit_permission
      fail("You are not authorized to edit other person's profile") unless
        user_params[:id].to_s == current_user.id.to_s
    end

    def user_params
      params.require(:id)
      params.permit(:id, :full_name, :email)
    end

    def json_update(user)
      response =
        ArborReloaded::UserService.new(user).update_user
      render json: response, status: (response.success ? 201 : 422)
    end
  end
end
