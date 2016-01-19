module ArborReloaded
  class UserService
    def initialize(user)
      @common_response = CommonResponse.new(true, [])
      @user = user
    end

    def update_user
      @common_response.data = { id: @user.id }
      @common_response.success = @user.save
      @common_response.errors += @user.errors.full_messages

      @common_response
    end
  end
end
