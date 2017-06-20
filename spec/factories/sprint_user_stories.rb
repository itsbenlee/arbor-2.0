FactoryGirl.define do
  factory :sprint_user_story do
    sprint     { create :sprint, project: create(:project) }
    user_story { create :user_story, project: sprint.project }
    status     { 'PLANNED' }

    trait :wip do
      status 'WIP'
    end

    trait :done do
      status 'DONE'
    end
  end
end
