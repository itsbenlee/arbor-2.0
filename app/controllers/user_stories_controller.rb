class UserStoriesController < ApplicationController
  before_action :load_user_story, only: [:show, :edit, :update]

  def index
    @user_stories = UserStory.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @user_story = UserStory.new(user_story_params)

    if @user_story.save
      redirect_to user_stories_path
    else
      @errors = @user_story.errors.full_messages
      render :new, status: 400
    end
  end

  def update
    if @user_story.save
      redirect_to user_stories_path
    else
      @errors = @user_story.errors.full_messages
      render :new, status: 400
    end
  end

  private

  def user_story_params
    params.require(:user_story).permit(
      %i(role action result estimated_points priority)
    )
  end

  def load_user_story
    @user_story = UserStory.find(params[:id])
  end
end
