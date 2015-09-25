class AcceptanceCriterionsController < ApplicationController
  before_action :set_user_story, only: :create
  before_action :set_acceptance_criterion, only: :update

  def create
    @ac_service = AcceptanceCriterionServices.new(@user_story)
    response =
      @ac_service.new_acceptance_criterion(acceptance_criterion_params)
    render json: response
  end

  def update
    @acceptance_criterion.update_attributes(acceptance_criterion_params)

    unless @acceptance_criterion.save
      flash[:alert] = @acceptance_criterion.errors.full_messages[0]
    end

    redirect_to :back
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
