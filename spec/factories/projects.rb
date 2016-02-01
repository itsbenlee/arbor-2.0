FactoryGirl.define do
  factory :project do
    sequence(:name)             { |n| Faker::Lorem.word + "(#{n})" }
    sequence(:slack_channel_id) { |n| Faker::Lorem.word + "(#{n})" }
    owner                       { create :user }
    members                     { [owner] }
    hypotheses                  { [] }
    copies                      { 0 }
  end

  trait :with_team do
    team { create :team }
  end
end
