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

  describe 'GET index' do
    let!(:tag)         { create :tag, project: project }
    let!(:another_tag) { create :tag, project: project }

    it 'should return the project tags' do
      post(:index, project_id: project.id)

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to be_truthy
      expect(
        (hash_response['data']['tags'] - [tag.name, another_tag.name]).empty?
      ).to be_truthy
    end
  end

  describe 'GET filter' do
    let!(:tag)           { create :tag, project: project }
    let!(:another_story) { create :user_story, role: 'user', project: project }
    render_views

    before :each do
      another_story.tags << tag
    end

    it 'should render the filtered stories', js: true do
      get(:filter, project_id: project.id, tag_names: [tag.name] )
      expect(response.body).to have_content(another_story.log_description)
      expect(response.body).not_to have_content(user_story.log_description)
    end
  end
end
