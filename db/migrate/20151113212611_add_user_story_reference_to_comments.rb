class AddUserStoryReferenceToComments < ActiveRecord::Migration
  def change
    add_reference :comments, :user_story, index: true, foreign_key: true
  end
end
