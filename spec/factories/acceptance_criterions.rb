FactoryGirl.define do
  factory :acceptance_criterion do
    sequence(:description) { |n| "#{n}:#{Faker::Lorem.sentence(4)}" }
    user_story             { create :user_story }
  end
end
