RSpec.describe Sprint, type: :model do
  it { should belong_to :project }
  it { should validate_presence_of :project }
  it { should have_many :sprint_user_stories }
  it { should have_many :user_stories }
end
