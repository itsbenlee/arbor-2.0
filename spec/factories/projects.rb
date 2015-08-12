FactoryGirl.define do
  factory :project do
    name  { Faker::Lorem.words(2).join(' ') }
    owner { create :user }
    members { [] }
  end
end
