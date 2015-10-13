class AcceptanceCriterionsController < ApplicationController
  before_action :set_user_story, only: :create
  before_action :set_acceptance_criterion, only: :update

  def create
    @ac_service = AcceptanceCriterionServices.new(@user_story)
    response =
      @ac_service.new_acceptance_criterion(acceptance_criterion_params)
    render json: response, status: (response.success ? 201 : 422)
  end

  def update
    @acceptance_criterion.update_attributes(acceptance_criterion_params)
    @ac_service =
      AcceptanceCriterionServices.new(@acceptance_criterion.user_story)
    response =
      @ac_service.update_acceptance_criterion(@acceptance_criterion)
    render json: response, status: (response.success ? 201 : 422)
  end

  private

  def acceptance_criterion_params
    params.require(:acceptance_criterion).permit(:description)
  end

  def set_user_story
    @user_story = UserStory.find(params[:user_story_id])
  end

  def set_acceptance_criterion
    @acceptance_criterion = AcceptanceCriterion.find(params[:id])
  end
end
