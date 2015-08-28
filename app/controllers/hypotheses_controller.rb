class HypothesesController < ApplicationController
  before_action :load_hypothesis, only: [:destroy]
  before_action :check_view_permission, only: [:index, :export]
  before_action :check_edit_permission, only: [:create, :update_order, :destroy]

  def index
    @hypothesis = Hypothesis.new(project_id: params[:project_id])
    @hypothesis_types = HypothesisType.all
  end

  def create
    @hypothesis = Hypothesis.new(hypothesis_params)
    @hypothesis.project = @project

    if @hypothesis.save
      @project.hypotheses << @hypothesis
      redirect_to project_hypotheses_path(@project)
    else
      @hypothesis_types = HypothesisType.all
      render :index
    end
  end

  def destroy
    @project.hypotheses.destroy(@hypothesis)

    redirect_to project_hypotheses_path(@project)
  end

  def update_order
    project_services = ProjectServices.new(@project)
    render json: project_services.reorder_hypotheses(hypothesis_order_params)
  end

  def export
    hypothesis_services = HypothesisServices.new(@project)

    respond_to do |format|
      format.csv do
        send_data(hypothesis_services.csv_export, disposition: 'inline')
      end
      format.json do
        send_data(hypothesis_services.json_export, disposition: 'inline')
      end
    end
  end

  private

  def set_project
    @project =
      @hypothesis.try(:project) ||
      Project
      .includes(:members, :canvas, hypotheses: [:user_stories, :goals])
      .order('hypotheses.order', 'user_stories.order')
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

  def load_hypothesis
    @hypothesis = Hypothesis.find(params[:id])
  end

  def hypothesis_params
    params.require(:hypothesis).permit(:description, :hypothesis_type_id)
  end

  def hypothesis_order_params
    params.require(:new_order)
  end
end
