module ArborReloaded
  class SprintUserStoriesController < ApplicationController
    include ArborReloaded::Concerns::ActAsProjectResource

    before_action :load_project
    before_action :load_sprint
    before_action :load_user_story

    def create
      sprint_user_story = SprintUserStory.find_or_create_by(
        sprint: @sprint, user_story: @user_story
      )

      @status = params[:status]

      if @status.blank?
        sprint_user_story.destroy
      else
        sprint_user_story.update(status: @status)
      end
    end

    private

    def load_sprint
      @sprint = @project.sprints.find(params[:sprint_id])
    end

    def load_user_story
      @user_story = @project.user_stories.find(params[:user_story_id])
    end
  end
end
