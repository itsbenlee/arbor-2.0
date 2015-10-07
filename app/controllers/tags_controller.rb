class TagsController < ApplicationController
  before_action :set_user_story, only: :create
  before_action :set_project, only: :create

  def create
    response = TagServices.new(@project, @user_story).new_tag(tag_params)
    render json: response
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_user_story
    @user_story = UserStory.find(params[:user_story_id])
  end

  def set_project
    @project =
      @tag.try(:project) ||
      Project.includes(:tags).find(params[:project_id])
  end
end
