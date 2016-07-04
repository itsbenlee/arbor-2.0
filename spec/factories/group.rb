FactoryGirl.define do
  factory :group do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
    project         { create :project }
  end
end
