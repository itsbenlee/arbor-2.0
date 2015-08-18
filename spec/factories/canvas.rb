FactoryGirl.define do
  factory :canvas do
    sequence(:problems)          { |n| Faker::Lorem.word + "#{n}" }
    sequence(:solutions)         { |n| Faker::Lorem.word + "#{n}" }
    sequence(:alternative)       { |n| Faker::Lorem.word + "#{n}" }
    sequence(:advantage)         { |n| Faker::Lorem.word + "#{n}" }
    sequence(:segment)           { |n| Faker::Lorem.word + "#{n}" }
    sequence(:channel)           { |n| Faker::Lorem.word + "#{n}" }
    sequence(:value_proposition) { |n| Faker::Lorem.word + "#{n}" }
    sequence(:revenue_streams)   { |n| Faker::Lorem.word + "#{n}" }
    sequence(:cost_structure)    { |n| Faker::Lorem.word + "#{n}" }
    project                      { create :project }
  end

  trait :uncomplete do
    problems nil
    solutions nil
    alternative nil
    advantage nil
    segment nil
    channel nil
    value_proposition nil
    revenue_streams nil
    cost_structure nil
  end

  trait :without_problems do
    problems nil
  end
end

