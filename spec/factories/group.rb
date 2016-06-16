FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
  end
end
