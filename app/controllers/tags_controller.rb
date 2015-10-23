class TagsController < ApplicationController
  before_action :set_user_story, only: :create
  before_action :set_project, only: [:filter, :index]
  before_action :set_tags, only: :filter

  def filter
    user_stories = []
    @tags.each do |tag|
      user_stories += tag.user_stories.where(project_id: @project.id)
    end

    render partial: 'user_stories/backlog_list',
           locals: { user_stories: user_stories, project: @project }
  end

  def index
    response = TagServices.new.tag_search(@project)
    render json: response, status: (response.success ? 201 : 422)
  end

  def create
    response = TagServices.new(@user_story).new_tag(tag_params)
    render json: response, status: (response.success ? 201 : 422)
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_user_story
    @user_story = UserStory.find(params[:user_story_id])
  end

  def set_tags
    @tags = Tag.where(name: params[:tag_names])
  end
end
