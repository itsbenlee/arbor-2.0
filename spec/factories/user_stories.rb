FactoryGirl.define do
  factory :user_story do
    role             { 'User' }
    action           { 'to be able to reset my password'}
    result           { 'I can recover my account' }
    estimated_points { 2 }
    project          { create :project }
  end

  trait :no_role do
    role nil
  end

  trait :no_action do
    action nil
  end

  trait :no_result do
    result nil
  end

  trait :no_role_and_action do
    role nil
    action nil
  end

  trait :no_role_and_result do
    role nil
    result nil
  end

  trait :no_action_and_result do
    action nil
    result nil
  end
end
