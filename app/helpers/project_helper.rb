module ProjectHelper
  def total_cost(project)
    velocity      = project.velocity
    cost_per_week = project.cost_per_week
    total_points  = UserStory.total_points(project.user_stories)

    return 0 unless velocity && cost_per_week

    cost_per_week * (total_points / velocity)
  end

  def total_weeks(project)
    velocity      = project.velocity
    total_points  = UserStory.total_points(project.user_stories)

    return 0 unless velocity

    total_points / velocity
  end
end
