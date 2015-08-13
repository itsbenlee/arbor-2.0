User.find_or_initialize_by(email: 'admin@getarbor.io') do |user|
  user.full_name = 'Admin NeonRoots'
  user.password = 'password'
  user.password_confirmation = 'password'
  user.admin = true
  user.save
end

%w(ACQUISITION ACTIVATION RETENTION REVENUE REFERRAL VALUE_PROPOSITION).each {
  |htype|
  HypothesisType.find_or_initialize_by(code: htype) do |hypothesis_type|
    hypothesis_type.description = htype.humanize
    hypothesis_type.save
  end
}
