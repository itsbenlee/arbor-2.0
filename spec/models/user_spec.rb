require 'spec_helper'

RSpec.describe User do
  describe 'validations' do
    let(:user) { build :user }
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
    it { is_expected.to callback(:update_intercom).after(:update).if(:email_changed?) }
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

  describe 'intercom integration' do
    let(:user) { create :user }

    before do
      stub_const('User::INTERCOM_ENABLED', true)
    end

    it 'should create a new intercom user' do
      user.email = 'sam_kemmer@gutmann.info'

      VCR.use_cassette('intercom/create_user') do
        expect { user.save! }.not_to raise_error
      end
    end
  end
end
