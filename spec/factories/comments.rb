FactoryGirl.define do
  factory :comment do
    sequence(:comment) { |n| "#{n}:#{Faker::Lorem.sentence(4)}" }
    user               { create :user }
  end
end
