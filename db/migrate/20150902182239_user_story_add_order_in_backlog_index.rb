class UserStoryAddOrderInBacklogIndex < ActiveRecord::Migration
  def change
    add_column :user_stories, :backlog_order, :integer, index: true
  end
end
