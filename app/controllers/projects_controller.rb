class ProjectsController < ApplicationController
  before_action :load_project, only: [:show, :edit, :update, :destroy, :log]

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
      redirect_to projects_path
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
    @activities = project_services.collect_log_entries

    render layout: false
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
