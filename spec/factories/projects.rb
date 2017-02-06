FactoryGirl.define do
  factory :project do
    sequence(:name)             { |n| Faker::Lorem.word + "(#{n})" }
    sequence(:slack_channel_id) { |n| Faker::Lorem.word + "(#{n})" }
    owner                       { create :user }
    copies                      0
  end

  trait :with_team do
    team { create :team }
  end

  trait :with_member do
    transient do
      member_to_add { create :user }
    end

    before :build, :create do |project, evaluator|
      project.members << evaluator.member_to_add
    end
  end
end
