class UserStoriesController < ApplicationController
  before_action :load_user_story, only: [:update, :destroy]
  before_action :check_edit_permission,
    only: [:create, :destroy, :update, :update_order]

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
      redirect_to project_hypotheses_path(@user_story.project)
    else
      @errors = @user_story.errors.full_messages
      render :edit, status: 400
    end
  end

  def destroy
    @user_story.destroy

    redirect_to project_hypotheses_path(@project)
  end

  def update_order
    @hypothesis_service = HypothesisServices.new(@project)
    render json: @hypothesis_service.reorder_stories(update_order_params)
  end

  private

  def set_project
    @project =
      @user_story.try(:project) ||
      Project
      .includes([:user_stories,
                 :members,
                 :hypotheses])
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

  def update_order_params
    params.require(:hypotheses)
  end
end
