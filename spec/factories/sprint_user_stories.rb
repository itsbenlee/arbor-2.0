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

    trait :with_story_without_points do
      user_story { create :user_story, :no_points, project: sprint.project }
    end
  end
end
