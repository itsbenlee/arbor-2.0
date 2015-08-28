class ProjectsController < ApplicationController
  before_action :load_project, only: [:show, :edit, :update, :destroy]

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
    assign_associations

    if @project.save
      redirect_to projects_path
    else
      @errors = @project.errors.full_messages
      render :new, status: 400
    end
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
      email if id.starts_with?('member')
    end.values.reject(&:blank?)
  end

  def assign_associations
    @project.owner ||= current_user
    ProjectMemberServices.new(@project, current_user, member_emails)
      .invite_members
  end
end
