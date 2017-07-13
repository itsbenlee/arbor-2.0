class CreateSprintUserStories < ActiveRecord::Migration
  def change
    create_table :sprint_user_stories do |t|
      t.references :sprint, index: true, foreign_key: true, null: false
      t.references :user_story, index: true, foreign_key: true, null: false
      t.string :status, null: false

      t.timestamps null: false
    end
  end
end
