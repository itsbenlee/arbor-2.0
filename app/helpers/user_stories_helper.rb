module UserStoriesHelper
  def format_story_points(user_story)
    points = user_story.estimated_points
    "#{points} #{points == 1 ? 'point' : 'points'}" if points
  end
end
