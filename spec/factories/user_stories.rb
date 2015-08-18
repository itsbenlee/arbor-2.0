FactoryGirl.define do
  factory :user_story do
    role     { 'user' }
    action   { 'be able to log in'}
    result   { 'so that I can use the app' }
    priority { 's' }
    project  { create :project }
  end
end
