class ChangeStatusDefaultSprinStories < ActiveRecord::Migration
  def change
    change_column_default :sprint_user_stories, :status, 'PLANNED'
  end
end
