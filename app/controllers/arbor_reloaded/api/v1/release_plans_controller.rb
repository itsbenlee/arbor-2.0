module ArborReloaded
  module Api
    module V1
      class ReleasePlansController < ApiBaseController
        before_action :set_release_plan_service

        def index
          json_response @release_plan_service.plan
        end

        private

        def set_release_plan_service
          @release_plan_service = ArborReloaded::ReleasePlanService.new(
            params[:project_id],
            current_user
          )
        end
      end
    end
  end
end
