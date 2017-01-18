module ArborReloaded
  class CanvasesController < ApplicationController
    layout 'application_reload'
    before_action :check_edit_permission

    helper_method :canvas
    helper_method :project
    helper_method :questions

    def index
    end

    def create
      canvas.update_attributes(canvas_params)
      render :index
    end

    private

    def canvas_params
      params.permit(:problems, :solutions, :alternative, :advantage, :segment,
                    :channel, :value_proposition, :revenue_streams,
                    :cost_structure)
    end

    def check_edit_permission
      project_auth = ProjectAuthorization.new(project)
      return if project_auth.member?(current_user)

      flash[:alert] = I18n.translate('can_not_edit')
      redirect_to root_url
    end

    def canvas
      @canvas ||= project.canvas ||= Canvas.new
    end

    def project
      @project ||= Project.includes(:canvas).find(params[:project_id])
    end

    def questions
      @questions ||= Canvas::QUESTIONS
    end
  end
end
