class AddStatusToSprintUserStories < ActiveRecord::Migration
  def change
    add_column :sprint_user_stories, :status, :string, null: false
  end
end
