require 'spec_helper'

RSpec.describe CommentsController do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    context 'for a new comment' do
      it 'should create comment' do
        request.env["HTTP_REFERER"] = project_user_stories_path project
        post(
          :create,
          user_story_id: user_story.id,
          comment:    { comment: 'My new comment' }
        )

        expect { Comment.count }.to become_eq 1
        hash_response = JSON.parse(response.body)
        expect(hash_response['success']).to eq(true)
        expect(hash_response['data']['edit_url']).to eq(edit_user_story_path(user_story))
      end
    end
  end
end
