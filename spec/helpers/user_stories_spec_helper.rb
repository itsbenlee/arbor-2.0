require 'factory_girl'

module UserStoriesSpecHelper
  include FactoryGirl
  def self.set_user_stories(quantity = 3, hypothesis)
    stories = []
    quantity.times { stories.push(create :user_story, hypothesis: hypothesis) }
    stories
  end

  def self.get_reordered(story_ids)
    UserStory.find(story_ids)
  end
end
