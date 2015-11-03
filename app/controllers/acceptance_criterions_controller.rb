class AcceptanceCriterionsController < ApplicationController
  before_action :load_acceptance_criterion, only: [:update, :destroy]
  before_action :set_user_story, only: [:create, :destroy]

  def create
    ac_service = AcceptanceCriterionServices.new(@user_story)
    response =
      ac_service.new_acceptance_criterion(acceptance_criterion_params)
    render json: response, status: (response.success ? 201 : 422)
  end

  def update
    @acceptance_criterion.update_attributes(acceptance_criterion_params)
    ac_service =
      AcceptanceCriterionServices.new(@acceptance_criterion.user_story)
    response =
      ac_service.update_acceptance_criterion(@acceptance_criterion)
    render json: response, status: (response.success ? 201 : 422)
  end

  def destroy
    @user_story.acceptance_criterions.destroy(@acceptance_criterion)
    acceptance_criterion_service = AcceptanceCriterionServices.new(
      @acceptance_criterion.user_story)
    response =
      acceptance_criterion_service.delete_acceptance_criterion(
        @acceptance_criterion)
    render json: response, status: (response.success ? 201 : 422)
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
