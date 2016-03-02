class UserStoriesController < ApplicationController
  before_action :load_user_story, only: [:update, :destroy, :edit, :comment]
  before_action :set_hypothesis, only: [:create]
  before_action :set_project, only: [:export]
  before_action :check_edit_permission,
    only: [:create, :destroy, :update, :update_order, :index, :edit]
  before_action :copied_user_stories, only: :copy

  def index
    @user_story = UserStory.new
    @total_points = @project.total_points
  end

  def edit
    render partial: 'user_stories/form',
           locals: { project: @project,
                     user_story: @user_story,
                     hypothesis: @user_story.hypothesis,
                     form_url: user_story_path(@user_story) }
  end

  def create
    @user_story_service = UserStoryService.new(@project, @hypothesis)
    response =
      @user_story_service.new_user_story(user_story_params, current_user)
    render json: response, status: (response.success ? 201 : 422)
  end

  def update
    respond_to do |format|
      @user_story.update_attributes(story_update_params)
      format.json do
        json_update
      end
      format.html do
        html_update
      end
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

  def copy
    user_story_service = UserStoryService.new(@project)
    user_story_service.copy_stories(@copied_stories)
    render json: { project_url: project_user_stories_path(@project) }
  end

  def export
    content = export_content
    save_pdf(content) unless params.key?('debug')
  end

  def reorder_criterions
    @user_story = UserStory.find(params['user_story'])
    acceptance_criterion_service = AcceptanceCriterionServices.new(@user_story)
    render json: acceptance_criterion_service.reorder_criterions(params)
  end

  def reorder_constraints
    @user_story = UserStory.find(params['user_story'])
    constraints_service = ConstraintServices.new(@user_story)
    render json: constraints_service.reorder_constraints(params)
  end

  private

  def story_update_params
    params = user_story_params
    params[:tag_ids] ||= []
    params[:archived]
    params
  end

  def export_content
    debug = params.key?('debug')
    project_name = @project.name
    cover_html = render_to_string(
      partial: 'user_stories/cover.html.haml',
      locals: { project_name: project_name }
    )
    send(
      debug ? :render : :render_to_string,
      pdf:          "#{project_name}",
      layout:       'application.pdf.haml',
      template:     'user_stories/index.pdf.haml',
      show_as_html: debug,
      cover: cover_html,
      margin: { top: 30, bottom: 30 }
    )
  end

  def save_pdf(content)
    send_data(
      content,
      filename: "#{@project.name} Backlog.pdf",
      type:     'application/pdf'
    )
  end

  def json_update
    response = UserStoryService.new(@project).update_user_story(@user_story)
    render json: response, status: (response.success ? 201 : 422)
  end

  def html_update
    if @user_story.save
      redirect_to :back
    else
      @errors = @user_story.errors.full_messages
      render :edit, status: 400
    end
  end

  def set_project
    @project =
      @user_story.try(:project) ||
      Project.includes(:user_stories)
      .order('user_stories.backlog_order')
      .find(params[:project_id])
  end

  def set_hypothesis
    hypothesis_id = user_story_params[:hypothesis_id]
    @hypothesis = hypothesis_id ? Hypothesis.find(hypothesis_id) : nil
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
      :role, :action, :result, :estimated_points,
      :priority, :archived, :hypothesis_id, :archived, tag_ids: []
    )
  end

  def update_order_params
    params.require(:hypotheses)
  end

  def copy_stories_params
    params.permit(:project_id, user_stories: [])
  end

  def copied_user_stories
    @project =
      Project.find(copy_stories_params[:project_id])
    @copied_stories = []
    copy_stories_params[:user_stories].each do |story_id|
      @copied_stories.push(UserStory.find(story_id))
    end
  end
end
