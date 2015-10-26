class RemoveEpicFromUserStory < ActiveRecord::Migration
  def change
    remove_column :user_stories, :epic, :boolean
  end
end
