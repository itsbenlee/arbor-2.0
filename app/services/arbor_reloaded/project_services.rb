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

    def reorder_stories(new_order)
      @project.reorder_user_stories(new_order)
      { success: true }
    end

    def all_activities
      @project.activities.all.order(created_at: :desc)
    end

    def replicate(current_user)
      replica =
        Project.new(name: replica_name,
                    owner: current_user,
                    members: [current_user])

      if replica.save && @project.save
        replicate_associations(replica)
        @common_response.data[:project] = replica
      end

      @common_response
    end

    def replicate_template(current_user)
      replica =
        Project.new(name: @project.name,
                    owner: current_user,
                    favorite: true,
                    members: [current_user])

      replicate_associations(replica) if replica.save && @project.save
    end

    def replica_name
      "Copy of #{@project.name} (#{@project.copies += 1})"
    end

    private

    def replicate_associations(replica)
      copy_stories(replica)
      @project.copy_canvas(replica) if @project.canvas
      replica.clean_log
    end

    def copy_stories(replica)
      @project.user_stories.each do |story|
        story.copy_in_project(replica)
      end
    end
  end
end
