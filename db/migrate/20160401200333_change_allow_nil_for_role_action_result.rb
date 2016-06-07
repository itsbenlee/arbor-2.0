class ChangeAllowNilForRoleActionResult < ActiveRecord::Migration
  def change
    change_column :user_stories, :role, :string, limit: 100, null: true
    change_column :user_stories, :action, :string, null: true
    change_column :user_stories, :result, :string, null: true
  end
end
