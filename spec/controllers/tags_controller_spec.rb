require 'spec_helper'

RSpec.describe TagsController, type: :controller do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'should create a tag' do
      expect {
        post(
          :create,
          user_story_id: user_story.id,
          project_id: project.id,
          tag: { name: 'My new tag' }
        )
      }.to change { Tag.count }.by 1

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to be_truthy
      expect(hash_response['data']['edit_url']).to eq(edit_user_story_path(user_story))
    end
  end

end
