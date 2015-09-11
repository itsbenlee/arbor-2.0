FactoryGirl.define do
  factory :project_activity, class: PublicActivity::Activity do
    owner     { create :user }
    trackable { create :project, owner: owner }
    key       { 'project.activity' }
  end
end
