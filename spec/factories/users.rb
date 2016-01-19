FactoryGirl.define do
  factory :user do
    email               { Faker::Internet.email }
    sequence(:slack_id) { |n| Faker::Lorem.word + "(#{n})" }
    full_name           { Faker::Name.name }
    password            { Devise.friendly_token[0, 20] }
  end
end
