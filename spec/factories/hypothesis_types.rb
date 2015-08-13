FactoryGirl.define do
  factory :hypothesis_type do
    sequence(:code)        { |n| Faker::Lorem.word + "(#{n})" }
    sequence(:description) { |n| Faker::Lorem.word + "(#{n})" }
  end
end
