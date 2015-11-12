class CommentsController < ApplicationController
  before_action :set_user_story, only: [:create]

  def create
    comment_service = CommentServices.new(@user_story)
    params = { comment: comment_params[:comment], user: current_user }
    response = comment_service.new_comment(params)
    render json: response, status: (response.success ? 201 : 422)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :user_story_id)
  end

  def set_user_story
    @user_story =
      @comment.try(:user_story) ||
      UserStory.find(params[:user_story_id])
  end
end
