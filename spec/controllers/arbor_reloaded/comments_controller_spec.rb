require 'spec_helper'

RSpec.describe ArborReloaded::CommentsController do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    context 'for a new comment' do
      it 'should create comment' do
        post(
          :create,
          format: :js,
          user_story_id: user_story.id,
          comment:    { comment: 'My new comment' }
        )

        expect{ Comment.count }.to become_eq 1
        expect(Comment.last.comment).to eq('My new comment')
        expect(Comment.last.user).to eq(user)
      end
    end
  end
end
