module ArborReloaded
  class UserStoriesController < ApplicationController
    layout 'application_reload'
    before_action :copied_user_stories, only: :copy
    before_action :next_and_prev_story, only: :show
    before_action :load_user_story, only: %i(edit update destroy color)
    before_action :check_edit_permission, only: :create
    before_action :set_project, only: %i(destroy_stories update ungrouped new)
    before_action :set_project_and_groups, only: %i(index show)

    def new
      user_story = UserStory.new

      render partial: 'arbor_reloaded/user_stories/form',
             locals: { project: @project,
                       user_story: user_story }
    end

    def index
      @user_story = UserStory.new
      @total_points = @project.total_points
      @new_group = Group.new
    end

    def show
      render layout: false
    end

    def edit
      render partial: 'user_stories/form',
             locals: { project: @project,
                       user_story: @user_story,
                       form_url: user_story_path(@user_story) }
    end

    def create
      story_services = ArborReloaded::UserStoryService.new(@project)
      @user_story =
        story_services.new_user_story(user_story_params, current_user)
      return unless @project.slack_iw_url
      ArborReloaded::SlackIntegrationService.new(@project)
        .user_story_notify(@user_story,
          arbor_reloaded_project_user_stories_url(@project))
    end

    def update
      @user_story.update_attributes(story_update_params)
      respond_to do |format|
        format.json do
          json_update
        end
        format.js do
          js_update
        end
      end
    end

    def copy
      user_story_service = ArborReloaded::UserStoryService.new(@project)
      user_story_service.copy_stories(@copied_stories)
      render json:
      { project_url: arbor_reloaded_project_user_stories_path(@project) }
    end

    def destroy
      @user_story.destroy
      redirect_to :back
    end

    def destroy_stories
      response =
        ArborReloaded::UserStoryService
        .new(@project).destroy_stories(destroy_stories_params[:user_stories])
      render json: response, status: (response.success ? 201 : 422)
    end

    def ungrouped
      render partial: 'arbor_reloaded/user_stories/ungrouped_list',
             locals: { project: @project }
    end

    def color
      @user_story.update_attribute('color', params[:color].try(:to_i))
      render json: @user_story.as_json
    end

    private

    def js_update
      return @user_story unless story_update_params['description']
      @user_story.update_attributes(role: nil, action: nil, result: nil)
    end

    def json_update
      if story_update_params[:estimated_points]
        ArborReloaded::IntercomServices.new(current_user)
          .create_event(t('intercom_keys.estimate_story'))
      end

      response =
        ArborReloaded::UserStoryService
        .new(@project).update_user_story(@user_story)
      render json: response, status: (response.success ? 201 : 422)
    end

    def story_update_params
      params = user_story_params
      params[:estimated_points] = nil if params[:estimated_points] == '?'
      params[:group_id] = nil if params[:group_id] == '?'
      params
    end

    def load_user_story
      @user_story =
        UserStory
        .includes(project: [:user_stories, :members])
        .find(params[:id])
    end

    def set_project
      @project =
        @user_story.try(:project) ||
        Project.includes(:user_stories)
        .order('user_stories.backlog_order')
        .find(params[:project_id])
    end

    def check_edit_permission
      set_project
      project_auth = ProjectAuthorization.new(@project)
      return if project_auth.member?(current_user)

      flash[:alert] = I18n.translate('can_not_edit')
      redirect_to root_url
    end

    def user_story_params
      params.require(:user_story).permit(:role, :action, :result,
        :estimated_points, :priority, :description, :group_id)
    end

    def copy_stories_params
      params.permit(:project_id, user_stories: [])
    end

    def destroy_stories_params
      params.require(:project_id)
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

    def next_and_prev_story
      load_user_story
      user_stories = @user_story.project.user_stories
      story_order = @user_story.backlog_order

      @prev_story =
        user_stories.find_by(backlog_order: story_order + 1)
      @next_story =
        user_stories.find_by(backlog_order: story_order - 1)
    end

    def set_project_and_groups
      check_edit_permission
      @groups = @project.groups
    end
  end
end
