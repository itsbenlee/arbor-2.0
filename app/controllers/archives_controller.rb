class ArchivesController < ApplicationController
  before_action :set_project, only: [:index, :list_archived]

  def index
    @user_stories = @project.user_stories.archived
  end

  def list_archived
    @user_stories = @project.user_stories.archived
    render partial: 'list_archived',
           locals: { user_stories: @user_stories.archived }
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
