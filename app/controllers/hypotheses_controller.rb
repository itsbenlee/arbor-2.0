class HypothesesController < ApplicationController
  before_action :check_view_permission, only: [:index]
  before_action :check_edit_permission, only: [:create]

  def index
    @hypothesis = Hypothesis.new(project_id: params[:project_id])
    @hypothesis_types = HypothesisType.all
  end

  def create
    @hypothesis = Hypothesis.new(hypothesis_params)
    @hypothesis.project = @project

    if @hypothesis.save
      redirect_to project_hypotheses_path(@project)
    else
      @hypothesis_types = HypothesisType.all
      render :index
    end
  end

  private

  def set_project
    @project =
      Project
      .includes([:hypotheses, :members])
      .order('hypotheses.order')
      .find(params[:project_id])
  end

  def check_view_permission
    set_project
    project_auth = ProjectAuthorization.new(@project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_view')
    redirect_to root_url
  end

  def check_edit_permission
    set_project
    project_auth = ProjectAuthorization.new(@project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_edit')
    redirect_to root_url
  end

  def hypothesis_params
    params.require(:hypothesis).permit(:description, :hypothesis_type_id)
  end
end
