FactoryGirl.define do
  factory :hypothesis do
    sequence(:description) { |n| Faker::Lorem.word + "(#{n})" }
    project                { create :project }
    hypothesis_type        { create :hypothesis_type }
  end
end
