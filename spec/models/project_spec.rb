require 'spec_helper'

describe Project do
  let(:project) { create :project, is_template: false }
  subject       { project }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:owner_id).with_message('Project name already exists') }
  it { should validate_uniqueness_of(:slack_channel_id) }
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
end
