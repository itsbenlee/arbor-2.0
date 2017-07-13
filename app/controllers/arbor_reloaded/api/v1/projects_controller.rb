module ArborReloaded
  module Api
    module V1
      class ProjectsController < ApiBaseController
        before_action :project, only: :create

        def create
          starting_date = project_params[:starting_date]

          @project.update(starting_date: starting_date) if starting_date

          render json: @project.as_json
        end

        private

        def project_params
          params.require(:project).permit(:name, :starting_date)
        end

        def project
          @project = current_user.owned_projects.find_or_create_by(
            name: project_params[:name]
          )
        end
      end
    end
  end
end
