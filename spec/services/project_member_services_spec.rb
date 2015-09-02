require 'spec_helper'
feature 'invite members' do
  let(:user)    { sign_in create :user }
  let(:project) { create :project, owner: user, members: [user] }

  context 'with both non users and users' do
    let(:another_user)   { create :user }
    let(:emails)         { ['email1@email.com', 'email2@email.com', another_user.email] }
    let(:member_service) { ProjectMemberServices.new(project, user, emails) }

    background do
      member_service.invite_members
    end

    scenario 'should add invites for the non users' do
      invites = Invite.all
      expect(invites[0].email).to eq('email1@email.com')
      expect(invites[0].project.name).to eq(project.name)
      expect(invites[1].email).to eq('email2@email.com')
      expect(invites[1].project.name).to eq(project.name)
    end

    scenario 'should not add invites for the users' do
      expect(Invite.count).to eq(2)
    end

    scenario 'should add the users as project members' do
      members = project.members
      expect(members[0].id).to be(user.id)
      expect(members[1].id).to be(another_user.id)
    end

    scenario 'should not add the non users to the project' do
      expect(project.members.count).to eq 2
    end
  end
end
