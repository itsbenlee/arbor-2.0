module ArborReloaded
  class CommentsController < ApplicationController
    before_action :set_user_story, only: [:create]

    def create
      @comment =
        Comment.new(comment: comment_params[:comment], user: current_user)
      @user_story.comments << @comment
      @user_story.project.create_activity :add_comment,
      owner: current_user,
      parameters:
        { user_story: @user_story.log_description,
          comment: @comment.comment } if @comment.save
    end

    def destroy
      comment = current_user.comments.find(params[:id])
      @user_story = comment.user_story
      comment.destroy
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
end
