RSpec.describe SprintUserStory, type: :model do
  subject { create :sprint_user_story }

  it { should belong_to :user_story }
  it { should belong_to :sprint }
  it { should validate_presence_of :status }
  it { should validate_presence_of :sprint }
  it { should validate_presence_of :user_story }
  it { should validate_inclusion_of(:status).in_array(SprintUserStory::STATUS) }
  it { should validate_uniqueness_of(:user_story_id).scoped_to(:sprint_id) }
  it { should validate_uniqueness_of(:sprint_id).scoped_to(:user_story_id) }

  describe 'user story and sprint belongs to different project' do
    let(:user_story) { create(:user_story, project: create(:project)) }
    let(:sprint)     { create(:sprint, project: create(:project)) }

    subject { build(:sprint_user_story, user_story: user_story, sprint: sprint) }

    it { should_not be_valid }
  end
end
