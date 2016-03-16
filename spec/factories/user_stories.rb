FactoryGirl.define do
  factory :user_story do
    role             { 'User' }
    action           { 'to be able to reset my password'}
    result           { 'I can recover my account' }
    estimated_points { 2 }
    project          { create :project }
    hypothesis       { create :hypothesis }
  end
end
