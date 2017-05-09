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
      @project
    end

    def all_activities
      @project.activities.all.order(created_at: :desc)
    end

    def replicate(current_user)
      replica = Project.new(name: replica_name,
                            owner: current_user,
                            velocity: @project.velocity,
                            cost_per_week: @project.cost_per_week)

      if replica.save && @project.save
        replicate_associations(replica)
        @common_response.data[:project] = replica
      end

      @common_response
    end

    def replicate_template(current_user)
      replica =
        Project.new(name: @project.name, owner: current_user, favorite: true)

      replicate_associations(replica) if replica.save && @project.save
    end

    private

    def replica_name
      "Copy of #{@project.name} (#{@project.copies += 1})"
    end

    def replicate_associations(replica)
      copy_groups(replica)
      copy_stories(replica)
      copy_canvas(replica)
      replica.clean_log
    end

    def copy_groups(replica)
      @project.groups.each { |group| group.deep_duplication(replica) }
    end

    def copy_canvas(replica)
      replica.canvas = @project.canvas.try(:clone)
    end

    def copy_stories(replica)
      @project
        .user_stories
        .backlog_ordered
        .each { |story| story.copy_in_project(replica) }

      replica.update_attribute :next_story_number, @project.next_story_number
    end
  end
end
