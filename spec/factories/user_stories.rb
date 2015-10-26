FactoryGirl.define do
  factory :user_story do
    role             { 'User' }
    action           { 'be able to reset my password'}
    result           { 'so that I can recover my account' }
    priority         { 'should' }
    estimated_points { 2 }
    project          { create :project }
    hypothesis       { create :hypothesis }
  end
end
