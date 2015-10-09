class CreateTagsUserStories < ActiveRecord::Migration
  def change
    create_table :tags_user_stories do |t|
      t.references :tag, null: false, index: true
      t.references :user_story, null: false, index: true
    end
  end
end
