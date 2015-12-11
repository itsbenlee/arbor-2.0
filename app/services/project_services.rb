class ProjectServices
  def initialize(project)
    @project = project
    @entries_per_page = ProjectServices.entries_per_page
    @common_response = CommonResponse.new(true, [])
  end

  def reorder_hypotheses(hypotheses)
    response = { success: true }
    if clean_hypotheses_order
      hypotheses.each do |_index, hypothesis|
        new_order = Hypothesis.new_order(hypothesis.symbolize_keys)
        response[:success] = false unless new_order
      end
    end
    response
  end

  def reorder_stories(new_order)
    @project.reorder_user_stories(new_order)
    { success: true }
  end

  def activities_by_pages
    @project.activities.order(created_at: :desc)
      .in_groups_of(@entries_per_page, false)
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

  def replica_name
    "Copy of #{@project.name} (#{@project.copies += 1})"
  end

  private

  def clean_hypotheses_order
    @project.hypotheses.update_all(order: nil)
    @project.save
  end

  def self.entries_per_page
    env_value = ENV['LOG_ENTRIES_PER_PAGE']
    env_value ? env_value.to_i : 5
  end

  def replicate_associations(replica)
    [
      Thread.new { @project.copy_hypothesis(replica) },
      Thread.new { @project.copy_stories(replica, nil, nil) },
      Thread.new { @project.copy_canvas(replica) if @project.canvas }
    ].each(&:join)
    replica.clean_log
  end
end
