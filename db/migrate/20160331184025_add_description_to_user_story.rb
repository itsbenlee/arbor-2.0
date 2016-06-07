class AddDescriptionToUserStory < ActiveRecord::Migration
  def change
    add_column :user_stories, :description, :text
  end
end
