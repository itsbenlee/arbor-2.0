FactoryGirl.define do
  factory :epic, class: UserStory do
    role     { 'User' }
    action   { 'be able to log in'}
    result   { 'so that I can use the app' }
    project  { create :project }
    epic     { true }
  end

  factory :user_story do
    role       { 'User' }
    action     { 'be able to reset my password'}
    result     { 'so that I can recover my account' }
    priority   { 's' }
    project    { create :project }
    hypothesis { create :hypothesis }
  end
end
