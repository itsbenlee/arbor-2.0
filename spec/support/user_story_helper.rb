module UserStoryHelper
  def set_user_stories(hypothesis)
    stories = []
    3.times { stories.push(create :user_story, hypothesis: hypothesis) }
    stories
  end

  def get_reordered(first_story, second_story, third_story)
    UserStory.find(first_story.id, second_story.id, third_story.id)
  end
end
