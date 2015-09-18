class CanvasesController < ApplicationController
  before_action :set_canvas, :check_edit_permission
  before_action :set_current_question, only: :create

  def index
    @current_question = 'problems'
  end

  def create
    @canvas.update_attributes(canvas_params)
    if env['HTTP_REFERER'].include? 'hypotheses'
      redirect_to :back
      return
    end
    render :index
  end

  private

  def set_current_question
    @current_question = params['current-question']
  end

  def canvas_params
    params.permit(:problems, :solutions, :alternative, :advantage, :segment,
                  :channel, :value_proposition, :revenue_streams,
                  :cost_structure)
  end

  def set_canvas
    @project = Project.includes(:canvas).find(params[:project_id])
    @canvas = @project.canvas ||= Canvas.new
  end

  def check_edit_permission
    project_auth = ProjectAuthorization.new(@project)
    return if project_auth.member?(current_user)

    flash[:alert] = I18n.translate('can_not_edit')
    redirect_to root_url
  end
end
