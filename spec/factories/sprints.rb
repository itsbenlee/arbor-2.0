FactoryGirl.define do
  factory :sprint do
    project { create :project }
  end
end
