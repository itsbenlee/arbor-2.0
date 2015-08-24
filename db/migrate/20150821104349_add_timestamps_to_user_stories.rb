class AddTimestampsToUserStories < ActiveRecord::Migration
  def change
    add_timestamps :user_stories
  end
end
