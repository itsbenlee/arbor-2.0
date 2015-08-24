FactoryGirl.define do
  factory :goal do
    sequence(:title) { |n| Faker::Lorem.word + "(#{n})" }
    hypothesis       { create :hypothesis }
  end
end
