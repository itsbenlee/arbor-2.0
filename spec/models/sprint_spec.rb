RSpec.describe Sprint, type: :model do
  it { should belong_to :project }
  it { should validate_presence_of :project }
  it { should have_many :sprint_user_stories }
  it { should have_many :user_stories }

  describe '.as_json' do
    describe 'with storiest without points' do
      let(:sprint) { create :sprint }
      let!(:user_story) do
        create(
          :sprint_user_story,
          :with_story_without_points,
          sprint: sprint
        ).user_story
      end

      subject { sprint.reload.as_json }

      it { should include(total_points: 0) }
      it { should include(user_stories: [user_story.as_json]) }
    end
  end
end
