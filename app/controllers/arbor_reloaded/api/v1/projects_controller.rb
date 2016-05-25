module ArborReloaded
  module Api
    module V1
      class ProjectsController < ApiBaseController
        before_action :set_user, only: :create

        def create
          project = @user.owned_projects.create(project_params)
          render json: project.as_json
        end

        private

        def project_params
          params.require(:project).permit(:name)
        end

        def set_user
          @user = @api_key.user
        end
      end
    end
  end
end
