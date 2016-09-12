require 'spec_helper'

RSpec.describe User do
  describe 'validations' do
    let(:user) { create :user }
    subject    { user }

    it { should validate_presence_of :full_name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of :email }
    it { should validate_uniqueness_of :slack_id }
    it { should validate_uniqueness_of :slack_auth_token }
    it { should have_many(:projects) }
    it { should have_many(:comments) }
    it { should have_many(:owned_projects) }
    it { should have_many(:teams) }
    it { should have_many(:owned_teams) }
  end

  describe 'available_projects' do
    let(:user) { create :user }
    let!(:team) { create :team, :with_user, user_to_add: user }
    let!(:owned_project) { create :project, owner: user }
    let!(:member_project) { create :project, :with_member, member_to_add: user }
    let!(:team_project) { create :project, team: team }

    it 'should include projects owned by the user' do
      expect(user.available_projects).to include(owned_project)
    end

    it 'should include projects where the user is member' do
      expect(user.available_projects).to include(member_project)
    end

    it 'should include projects shared with teams the user is member' do
      expect(user.available_projects).to include(team_project)
    end
  end
end
