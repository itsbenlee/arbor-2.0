module ArborReloaded
  module Concerns
    module ActAsProjectResource
      extend ActiveSupport::Concern

      included do
        rescue_from ActiveRecord::RecordNotFound do
          render 'errors/404', status: 404
        end
      end

      protected

      def load_project
        id = params[:id] || params[:project_id]
        @project = Project.find(id)
        has_access = current_user.available_projects.include?(@project)
        fail ActiveRecord::RecordNotFound unless has_access
      end
    end
  end
end
