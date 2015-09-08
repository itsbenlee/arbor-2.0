class ProjectServices
  def initialize(project)
    @project = project
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
    @project
      .reorder_user_stories(new_order)
    { success: true }
  end

  def activities_by_pages
    activities = []
    %w(project hypotheses goals).each do |entity|
      activities += send("collect_#{entity}_log_entries")
    end

    activities
      .sort_by(&:created_at)
      .reverse.in_groups_of ProjectServices.entries_per_page, false
  end

  private

  def clean_hypotheses_order
    @project.hypotheses.update_all(order: nil)
    @project.save
  end

  def collect_project_log_entries
    @project.activities
  end

  def collect_hypotheses_log_entries
    @project.hypotheses.collect(&:activities).flatten
  end

  def collect_goals_log_entries
    @project
      .hypotheses
      .collect(&:goals)
      .flatten
      .collect(&:activities)
      .flatten
  end

  def self.entries_per_page
    env_value = ENV['LOG_ENTRIES_PER_PAGE']
    env_value ? env_value.to_i : 5
  end
end
