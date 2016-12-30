require 'spec_helper'

describe Group do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user}
  let(:group)   { create :group, project: project}

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:project_id).case_insensitive }
  it { should validate_length_of(:name).is_at_most(100) }
  it { should have_many :user_stories }
  it { should belong_to :project }

  describe '#total_estimated_points' do
    context 'when it has no stories' do
      it { expect(group.total_estimated_points).to be(0) }
    end

    context 'when it has stories' do
      before(:each) do
        group.user_stories << create_list(:user_story, 3)
      end

      it { expect(group.total_estimated_points).to be(6) }
    end
  end
end
