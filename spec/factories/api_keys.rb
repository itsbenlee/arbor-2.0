FactoryGirl.define do
  factory :api_key do
    user { create :user }
  end
end
