FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
  end
end
