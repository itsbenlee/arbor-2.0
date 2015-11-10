class ConstraintsController < ApplicationController
  before_action :load_constraint, only: [:update, :destroy]
  before_action :set_user_story, only: [:create, :destroy]

  def create
    constraint_service = ConstraintServices.new(@user_story)
    response = constraint_service.new_constraint(constraint_params)
    render json: response, status: (response.success ? 201 : 422)
  end

  def update
    @constraint.update_attributes(constraint_params)
    constraint_service = ConstraintServices.new(@constraint.user_story)
    response =
      constraint_service.update_constraint(@constraint)
    render json: response, status: (response.success ? 201 : 422)
  end

  def destroy
    @user_story.constraints.destroy(@constraint)
    constraint_service = ConstraintServices.new(@constraint.user_story)
    response =
      constraint_service.delete_constraint(@constraint)
    render json: response, status: (response.success ? 201 : 422)
  end

  private

  def constraint_params
    params.require(:constraint).permit(:description, :user_story_id)
  end

  def set_user_story
    @user_story =
      @constraint.try(:user_story) ||
      UserStory.find(params[:user_story_id])
  end

  def load_constraint
    @constraint = Constraint.includes([:user_story]).find(params[:id])
  end
end
