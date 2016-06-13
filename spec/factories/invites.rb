FactoryGirl.define do
  factory :invite do
    email { Faker::Internet.email }
  end

  trait :project_invite do
    project { create :project }
  end

  trait :team_invite do
    team { create :team }
  end
end
