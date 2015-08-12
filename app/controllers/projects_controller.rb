class ProjectsController < ApplicationController
  before_action :load_project, only: [:show]

  def index
  end

  def new
  end

  def show
  end

  def create
    @project = Project.new(project_params)
    @project.owner = current_user

    if @project.save
      MembersProject.create(project: @project, member: current_user)
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
end
