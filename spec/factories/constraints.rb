FactoryGirl.define do
  factory :constraint do
    sequence(:description) { |n| "#{n}:#{Faker::Lorem.sentence(4)}" }
    user_story             { create :user_story }
  end
end
