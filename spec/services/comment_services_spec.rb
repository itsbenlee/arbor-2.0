require 'spec_helper'

feature 'create comment' do
  let(:project)         { create :project }
  let(:user_story)      { create :user_story }
  let(:current_user)    { create :user }
  let(:comment_service) { CommentServices.new(user_story) }
  let(:comment_params)  {
    {
      user_story_id: user_story.id,
      comment: 'My new comment'
    }
  }

  scenario 'should create a Comment and assign the params' do
    response = comment_service.new_comment(comment_params, current_user)
    expect(response.success).to eq(true)
    comment = Comment.last
    expect(comment).to be_a(Comment)
    expect(comment.comment).to eq('My new comment')
    expect(comment.user).to eq(current_user)
    expect(user_story.comments.first).to eq(comment)
  end
end
