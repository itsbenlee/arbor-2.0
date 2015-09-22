FactoryGirl.define do
  factory :acceptance_criterion do
    sequence(:description) { |n| "#{Faker::Lorem.word}(#{n})" }
    user_story             { create :user_story }
  end
end
