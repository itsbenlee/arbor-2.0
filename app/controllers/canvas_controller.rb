class CanvasController < ApplicationController
  before_action :set_canvas, :check_edit_permission

  def index
  end

  def create
    @canvas.update_attributes(canvas_params)
    redirect_to project_canvas_path(@project)
  end

  private

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
