FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
  end
end
