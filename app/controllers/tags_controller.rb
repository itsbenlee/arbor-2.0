class TagsController < ApplicationController
  before_action :set_user_story, only: :create

  def create
    response = TagServices.new(@user_story).new_tag(tag_params)
    render json: response, status: (response.success ? 201 : 422)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_user_story
    @user_story = UserStory.find(params[:user_story_id])
  end
end
