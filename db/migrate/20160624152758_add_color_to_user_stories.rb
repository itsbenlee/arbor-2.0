class AddColorToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :color, :integer
  end
end
