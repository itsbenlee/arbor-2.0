require 'spec_helper'

describe Invite do
  let(:project) { create :project }
  let!(:invite) { create :invite, email: 'test@test.com', project: project }

  it { should validate_presence_of :email }
  it { should validate_presence_of :project }
  it { should validate_uniqueness_of(:email).scoped_to(:project_id)}
  it { should belong_to :project }

  it 'must not accept duplicate invites' do
    expect{ create :invite, email: 'test@test.com', project: project }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'must accept same email and different project' do
    project2 = create :project
    expect{ create :invite, email: 'test@test.com', project: project2 }
      .not_to raise_error
  end

  it 'must accept same project and different email' do
    expect{ create :invite, email: 'test2@test2.com', project: project }
      .not_to raise_error
  end
end
