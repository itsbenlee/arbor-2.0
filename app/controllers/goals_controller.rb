class GoalsController < ApplicationController
  before_action :load_goal, only: [:edit, :update, :destroy]
  before_action :set_hypothesis
  before_action :check_edit_permission, only: [:create, :update, :destroy]

  def create
    @goal = Goal.new(goal_params)
    @goal.hypothesis = @hypothesis

    if @goal.save
      @hypothesis.goals << @goal
      redirect_to project_hypotheses_path(@hypothesis.project)
    else
      @errors = @goal.errors.full_messages
      render :new, status: 400
    end
  end

  def edit
  end

  def update
    @goal.update_attributes(goal_params)

    if @goal.save
      redirect_to project_hypotheses_path(@hypothesis.project)
    else
      @errors = @goal.errors.full_messages
      render :edit, status: 400
    end
  end

  def destroy
    @hypothesis.goals.destroy(@goal)

    redirect_to project_hypotheses_path(@hypothesis.project)
  end

  private

  def check_edit_permission
    project_auth = ProjectAuthorization.new(@hypothesis.project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_edit')
    redirect_to root_url
  end

  def goal_params
    params.require(:goal).permit(:title, :hypothesis_id)
  end

  def load_goal
    @goal = Goal.includes([:hypothesis]).find(params[:id])
  end

  def set_hypothesis
    @hypothesis =
      @goal.try(:hypothesis) ||
      Hypothesis
      .find(params[:hypothesis_id])
  end
end
