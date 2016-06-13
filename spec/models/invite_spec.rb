require 'spec_helper'

describe Invite do
  describe '#project_invite' do
    let(:project_invite) { create :invite, :project_invite }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).scoped_to(:project_id) }
    it { should belong_to :project }

    it 'must not accept duplicate invites' do
      expect{
        create :invite, email: project_invite.email, project: project_invite.project
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must accept same email and different project' do
      project2 = create :project

      expect{
        create :invite, email: project_invite.email, project: project2
      }.not_to raise_error
    end

    it 'must accept same project and different email' do
      expect{
        create :invite, email: 'test2@test2.com', project: project_invite.project
      }.not_to raise_error
    end

    it_behaves_like 'a logged entity' do
      let(:entity)      { build :invite, email: 'test@mail.com' }
      let(:description) { 'test@mail.com' }
    end
  end

  describe '#team_invite' do
    let(:team_invite) { create :invite, :team_invite }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).scoped_to(:team_id) }
    it { should belong_to :team }

    it 'must not accept duplicate invites' do
      expect{
        create :invite, email: team_invite.email, team: team_invite.team
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'must accept same email and different team' do
      team2 = create :team

      expect{
        create :invite, email: team_invite.email, team: team2
      }.not_to raise_error
    end

    it 'must accept same project and different email' do
      expect{
        create :invite, email: 'test2@test2.com', team: team_invite.team
      }.not_to raise_error
    end

    it_behaves_like 'a logged entity' do
      let(:entity)      { build :invite, email: 'test@mail.com' }
      let(:description) { 'test@mail.com' }
    end
  end
end
