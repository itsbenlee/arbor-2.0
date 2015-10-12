class TouchAllUserStories < ActiveRecord::Migration
  def change
    UserStory.all.each(&:save)
  end
end
