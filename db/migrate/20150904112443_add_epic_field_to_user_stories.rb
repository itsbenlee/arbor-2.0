class AddEpicFieldToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :epic, :boolean, index: true, default: false
  end
end
