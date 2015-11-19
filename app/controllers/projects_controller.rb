class ProjectsController < ApplicationController
  before_action :load_project,
                only: [:show, :edit, :update, :destroy,
                       :log, :export_to_spreadhseet]

  def index
  end

  def new
  end

  def edit
  end

  def show
    @invites = Invite.where(project: @project)
    @can_delete = current_user.can_delete?(@project)
  end

  def destroy
    @project.destroy
    redirect_to projects_path
  end

  def remove_member_from_project
    project = params['project_id']
    member_to_destroy = MembersProject.find_by(member_id: params['member'],
                                               project_id: project)

    if member_to_destroy.destroy
      redirect_to project_path(project)
    else
      @errors = m.errors.full_messages
      render :edit, status: 400
    end
  end

  def update
    @project.update_attributes(name: project_params[:name])
    assign_associations

    if @project.save
      redirect_to project_path @project
    else
      @errors = @project.errors.full_messages
      render :edit, status: 400
    end
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      assign_associations
      redirect_to project_canvases_path(@project)
    else
      @errors = @project.errors.full_messages
      render :new, status: 400
    end
  end

  def order_stories
    project = Project.includes(:user_stories).find(params[:project_id])
    project_services = ProjectServices.new(project)
    render json: project_services.reorder_stories(update_order_params)
  end

  def log
    project_services = ProjectServices.new(@project)
    @activities_by_pages = project_services.activities_by_pages

    render layout: false
  end

  def backlog
    project = Project.includes(
      user_stories: [:acceptance_criterions, :constraints],
      members: {},
      hypotheses: {})
              .order('user_stories.backlog_order')
              .find(params[:project_id])
    user_stories = project.user_stories

    render partial: 'user_stories/backlog_list',
           locals:
           {
             user_stories: user_stories,
             project: project,
             total_points: UserStory.total_points(user_stories)
           }
  end

  def copy
    project =
      Project
      .includes(user_stories: [:acceptance_criterions, :constraints],
                hypotheses: [:user_stories, :goals])
      .find(params[:project_id])

    project_services = ProjectServices.new(project)
    project_services.replicate(current_user)

    redirect_to :back
  end

  def export_to_spreadhseet
    send_data(
      SpreadsheetExporterService.export(@project), disposition: 'inline')
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

  def load_project
    @project = Project.find(params[:id])
  end

  def member_emails
    params[:project].select do |id, email|
      email if id.starts_with?('member') && email != current_user.email
    end.values.reject(&:blank?).uniq
  end

  def assign_associations
    @project.owner ||= current_user
    ProjectMemberServices.new(
      @project, current_user, member_emails
    ).invite_members
  end

  def update_order_params
    params.require(:stories)
  end
end
