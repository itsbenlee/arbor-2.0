class AddStoryNumberToUserStory < ActiveRecord::Migration
  def change
    add_column :user_stories, :story_number, :integer
    add_index :user_stories, :story_number
  end
end
