require 'factory_girl'

module UserStoriesSpecHelper
  include FactoryGirl

  def self.set_user_stories(quantity = 3, hypothesis)
    create_list :user_story, quantity, hypothesis: hypothesis
  end

  def self.get_reordered(story_ids)
    UserStory.find(story_ids)
  end
end
