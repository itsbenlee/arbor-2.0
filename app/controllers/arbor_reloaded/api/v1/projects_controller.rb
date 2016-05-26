module ArborReloaded
  module Api
    module V1
      class ProjectsController < ApiBaseController
        def create
          project = current_user.owned_projects.create(project_params)
          render json: project.as_json
        end

        private

        def project_params
          params.require(:project).permit(:name)
        end
      end
    end
  end
end
