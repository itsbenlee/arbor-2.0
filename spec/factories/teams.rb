FactoryGirl.define do
  factory :team do
    sequence(:name) { |n| Faker::Lorem.word + "(#{n})" }
    owner           { create :user }
    users           { [owner] }

    trait :with_user do
      transient do
        user_to_add { create :user }
      end

      before :build, :create do |team, evaluator|
        team.users << evaluator.user_to_add
      end
    end
  end
end
