require 'spec_helper'

describe Group do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user}
  let(:group)   { create :group, project: project}

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name).scoped_to(:project_id) }
  it { should have_many :user_stories }
  it { should belong_to :project }
end
