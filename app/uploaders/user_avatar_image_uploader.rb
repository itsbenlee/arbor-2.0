class UserAvatarImageUploader < GenericImageUploader
  def default_url(*)
    ActionController::Base.helpers.image_path('test-user.png')
  end
end
