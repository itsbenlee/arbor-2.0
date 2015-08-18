class UserStoriesController < ApplicationController
  before_action :check_edit_permission, only: [:create]
  before_action :set_project, only: [:edit, :create, :update]
  before_action :load_user_story, only: [:edit, :update]

  def edit
  end

  def create
    @user_story = UserStory.new(user_story_params)
    @user_story.project = @project

    if @user_story.save
      redirect_to project_hypotheses_path(@project)
    else
      @errors = @user_story.errors.full_messages
      render :new, status: 400
    end
  end

  def update
    @user_story.update_attributes(user_story_params)
    if @user_story.save
      redirect_to project_hypotheses_path(@project)
    else
      @errors = @user_story.errors.full_messages
      render :edit, status: 400
    end
  end

  private

  def set_project
    @project =
      Project
      .includes([:user_stories, :members])
      .find(params[:project_id])
  end

  def check_edit_permission
    set_project
    project_auth = ProjectAuthorization.new(@project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_edit')
    redirect_to root_url
  end

  def load_user_story
    @user_story = UserStory.find(params[:id])
  end

  def user_story_params
    params.require(:user_story).permit(
      %i(role action result estimated_points priority, hypothesis_id)
    )
  end
end
