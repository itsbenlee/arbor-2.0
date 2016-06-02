require 'spec_helper'

describe Project do
  let(:project) { create :project, is_template: false }
  let(:user)    { create :user }
  let(:team)    { create :team, users: [user] }

  subject       { project }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:owner_id).with_message('Project name already exists') }
  it { should validate_uniqueness_of(:slack_channel_id).allow_nil }
  it { should validate_uniqueness_of(:slack_iw_url).allow_nil }
  it { should have_many :invites }
  it { should have_many :members }
  it { should have_many :hypotheses }
  it { should have_many :user_stories }
  it { should have_many :attachments }
  it { should have_many :tags }
  it { should belong_to :owner }
  it { should belong_to :team }
  it { should_not validate_uniqueness_of(:is_template) }

  context 'if is_tremplate is true' do
    before :each do
      project.update_attributes(is_template: true)
    end

    it { should validate_uniqueness_of(:is_template) }
  end

  it_behaves_like 'a logged entity' do
    let(:entity)      { build :project, name: 'Test project' }
    let(:description) { nil }
  end

  describe 'add member' do
    it 'adds a member and creates an activity' do
      PublicActivity.with_tracking do
        project.add_member(user)
        expect(project.members).to include(user)
        expect(PublicActivity::Activity.last.key).to eq('project.add_member')
      end
    end
  end

  describe 'assign_team' do
    it 'assigns team and owner without logging activity' do
      PublicActivity.with_tracking do
        project.assign_team(team.name, user)
        expect(project.members).to include(team.owner)
        expect(project.team).to eq(team)
        expect(project.owner).to eq(team.owner)
        expect(PublicActivity::Activity.last).to eq(nil)
      end
    end
  end

  describe 'owner_as_member' do
    it 'should assign owner as member' do
      expect(project.members).to include(project.owner)
    end
  end
end
