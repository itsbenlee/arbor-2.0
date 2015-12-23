module ArborReloaded
  class ProjectServices
    def initialize(project)
      @project = project
      @common_response = CommonResponse.new(true, [])
    end

    def update_project
      route_helper = Rails.application.routes.url_helpers

      if @project.save
        @common_response.data[:return_url] =
          route_helper.arbor_reloaded_projects_list_path
      else
        @common_response.success = false
        @common_response.errors += @project.errors.full_messages
      end
      @common_response
    end

    def projects_json_list(projects)
      project_list = []

      projects.each do |project|
        project_list << project.name_url_hash
      end

      @common_response.data[:projects] = project_list
      @common_response.success = false unless @common_response
      @common_response
    end

    def all_activities
      @project.activities.all.order(created_at: :desc)
    end
  end
end
