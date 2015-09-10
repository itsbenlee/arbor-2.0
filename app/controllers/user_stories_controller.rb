class UserStoriesController < ApplicationController
  before_action :load_user_story, only: [:update, :destroy, :edit]
  before_action :set_hypothesis, only: [:create]
  before_action :check_edit_permission,
    only: [:create, :destroy, :update, :update_order, :index, :edit]

  def index
    @user_story = UserStory.new
  end

  def edit
    render partial: 'user_stories/form',
           locals: { project: @project,
                     user_story: @user_story,
                     hypothesis: @user_story.hypothesis,
                     form_url: user_story_path(@user_story) }
  end

  def create
    @user_story = UserStory.new(user_story_params)
    @user_story.project = @project

    if @user_story.save
      update_associations
      redirect_to :back
    else
      @errors = @user_story.errors.full_messages
      render :new, status: 400
    end
  end

  def update
    @user_story.update_attributes(user_story_params)
    if @user_story.save
      redirect_to :back
    else
      @errors = @user_story.errors.full_messages
      render :edit, status: 400
    end
  end

  def destroy
    @project.user_stories.destroy(@user_story)

    redirect_to :back
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
      .order('user_stories.backlog_order')
      .find(params[:project_id])
  end

  def set_hypothesis
    hypothesis_id = user_story_params[:hypothesis_id]
    @hypothesis = Hypothesis.find(hypothesis_id) if hypothesis_id
  end

  def check_edit_permission
    set_project
    project_auth = ProjectAuthorization.new(@project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_edit')
    redirect_to root_url
  end

  def load_user_story
    @user_story =
      UserStory
      .includes(project: [:user_stories, :members, :hypotheses])
      .find(params[:id])
  end

  def user_story_params
    params.require(:user_story).permit(
      %i(role action result estimated_points priority hypothesis_id epic)
    )
  end

  def update_order_params
    params.require(:hypotheses)
  end

  def update_associations
    @project.user_stories << @user_story
    @project.update_attribute :next_story_number, @project.next_story_number + 1
    @hypothesis.user_stories << @user_story if @hypothesis
  end
end
