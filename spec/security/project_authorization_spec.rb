require 'spec_helper'

describe 'Project authorization' do
  before :each do
    @user = create :user
    @project = create :project, { members: [@user] }
  end

  it 'check if user is member' do
    project_auth = ProjectAuthorization.new(@project)
    expect(project_auth.member?(@user)).to be_truthy
  end

  it 'check if user is not member' do
    project_auth = ProjectAuthorization.new(@project)
    no_member_user = create :user
    expect(project_auth.member?(no_member_user)).to be_falsey
  end
end
