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
        allow_any_instance_of(ArborReloaded::IntercomServices)
          .to receive(:comment_create_event).and_return(true)

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

  describe 'DELETE destroy' do
    let!(:comment) { create :comment, user_story: user_story, user: user }

    it 'deletes the comment' do
      delete :destroy, format: :js, id: comment.id
      expect(Comment.exists? comment.id).to be false
    end
  end
end
