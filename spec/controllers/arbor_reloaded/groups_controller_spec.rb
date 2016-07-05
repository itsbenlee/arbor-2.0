require 'spec_helper'

RSpec.describe ArborReloaded::GroupsController do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  before :each do
    request.env["HTTP_REFERER"] = '/'
  end

  describe 'DELETE group' do
    let!(:group)   { create :group, project: project }

    before :each do
      sign_in user
    end

    it 'deletes the group' do
      delete :destroy, { id: group.to_param }
      expect(Group.exists? group.id).to be false
    end
  end
end
