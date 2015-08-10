User.find_or_initialize_by(email: 'admin@getarbor.io') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = true
  user.save
end
