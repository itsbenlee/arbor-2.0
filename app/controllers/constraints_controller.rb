class ConstraintsController < ApplicationController
  before_action :load_constraint, only: :update
  before_action :set_user_story, only: :create

  def create
    constraint = Constraint.new(constraint_params)
    constraint.user_story = @user_story

    if constraint.save
      @user_story.constraints << constraint
    else
      flash[:alert] = acceptance_criterion.errors.full_messages[0]
    end

    redirect_to :back
  end

  def update
    @constraint.update_attributes(constraint_params)

    flash[:alert] = @constraint.errors.full_messages[0] unless @constraint.save

    redirect_to :back
  end

  private

  def constraint_params
    params.require(:constraint).permit(:description, :user_story_id)
  end

  def load_constraint
    @constraint = Constraint.includes([:user_story]).find(params[:id])
  end

  def set_user_story
    @user_story = UserStory.find(params[:user_story_id])
  end
end
