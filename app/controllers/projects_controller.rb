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

  def fetch_members
    emails = params[:project].select do |id, email|
      email if id.starts_with?('member')
    end.values

    emails.map { |email| User.find_by(email: email) }.compact
  end

  def assign_associations
    @project.owner = current_user
    @project.members = fetch_members << current_user
  end
end
