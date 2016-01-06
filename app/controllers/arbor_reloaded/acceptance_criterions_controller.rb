module ArborReloaded
  class AcceptanceCriterionsController < ApplicationController
    before_action :set_user_story, only: [:create]

    def create
      ac_service = CriterionServices.new(@user_story)
      @criterion =
        ac_service.new_acceptance_criterion(acceptance_criterion_params)
    end

    private

    def acceptance_criterion_params
      params.require(:acceptance_criterion).permit(:description, :user_story_id)
    end

    def set_user_story
      @user_story =
        @acceptance_criterion.try(:user_story) ||
        UserStory.find(params[:user_story_id])
    end
  end
end
