FactoryGirl.define do
  factory :user do
    email               { Faker::Internet.email }
    sequence(:slack_id) { |n| Faker::Lorem.word + "(#{n})" }
    full_name           { Faker::Name.name }
    password            { Devise.friendly_token[0, 20] }
    avatar              { nil }
  end


  trait :with_avatar do
    avatar Rack::Test::UploadedFile.new(
      File.join(Rails.root, 'spec', 'support', 'test-user.png')
    )
  end
end
