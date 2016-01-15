module ArborReloaded
  class AcceptanceCriterionsController < ApplicationController
    before_action :set_user_story, only: [:create]
    before_action :load_acceptance_criterion, only: [:update, :destroy]

    def create
      ac_service = CriterionServices.new(@user_story)
      @criterion =
        ac_service.new_acceptance_criterion(acceptance_criterion_params)
    end

    def update
      @acceptance_criterion.update_attributes(acceptance_criterion_params)
    end

    def destroy
      @user_story = @acceptance_criterion.user_story
      @acceptance_criterion.destroy
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

    def load_acceptance_criterion
      @acceptance_criterion = AcceptanceCriterion.find(params[:id])
    end
  end
end
