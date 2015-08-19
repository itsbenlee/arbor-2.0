FactoryGirl.define do
  factory :invite do
    email    { Faker::Internet.email }
    project  { create :project }
  end
end
