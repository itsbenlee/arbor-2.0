module UserStoryHelper
  def set_user_stories(hypothesis)
    create_list :user_story, 3, hypothesis: hypothesis
  end

  def set_user_stories_on_project(project)
    create_list :user_story, 3, project: project
  end
  
  def get_reordered(first_story, second_story, third_story)
    UserStory.find(first_story.id, second_story.id, third_story.id)
  end
end
