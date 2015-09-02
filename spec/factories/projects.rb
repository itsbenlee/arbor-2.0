FactoryGirl.define do
  factory :project do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
    owner           { create :user }
    members         { [owner] }
    hypotheses      { [] }
  end
end
