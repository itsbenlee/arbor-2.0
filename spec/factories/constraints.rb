FactoryGirl.define do
  factory :constraint do
    sequence(:description) { |n| "#{Faker::Lorem.word}(#{n})" }
    user_story             { create :user_story }
  end
end
