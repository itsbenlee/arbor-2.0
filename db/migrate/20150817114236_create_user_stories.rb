class CreateUserStories < ActiveRecord::Migration
  def change
    create_table :user_stories do |t|
      t.string  :role, limit: 100, null: false
      t.string  :action, limit: 255, null: false
      t.string  :result, limit: 255, null: false

      t.integer :estimated_points, limit: 2
      t.string  :priority, limit: 1, default: 's'
    end
  end
end
