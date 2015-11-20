class AddArchivedToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :archived, :boolean, default: false
  end
end
