FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
    owner           { create :user }
    users           { [owner] }
  end
end
