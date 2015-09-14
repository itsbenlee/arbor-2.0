class HypothesesController < ApplicationController
  before_action :load_hypothesis, only: [:destroy, :update]
  before_action :check_view_permission,
    only: [:index, :export, :export_to_trello]
  before_action :check_edit_permission, only: [:create, :update_order, :destroy]
  before_action :set_user_strories, only: :index

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

  def update
    @hypothesis.update_attributes(hypothesis_params)
    @hypothesis.save
    redirect_to :back
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

  def export_to_trello
    TrelloServices.new(@project, trello_export_params).export
    redirect_to :back
  end

  private

  def set_project
    @project =
      @hypothesis.try(:project) ||
      Project
      .includes(:members, :canvas, hypotheses: [:user_stories, :goals])
      .order('hypotheses.order', 'user_stories.order', 'goals.created_at')
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

  def trello_export_params
    params.require(:token)
  end

  def set_user_strories
    @independent_stories =
      @project.user_stories.where(hypothesis_id: nil)
  end
end
