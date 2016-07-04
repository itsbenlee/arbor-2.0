module ArborReloaded
  module Api
    module V1
      class GroupsController < ApiBaseController
        before_action :set_project

        def create
          render json: @project.groups.find_or_create_by(group_params).as_json
        end

        private

        def set_project
          @project = Project.find(params[:project_id])
        end

        def group_params
          params.require(:group).permit(:name)
        end
      end
    end
  end
end
