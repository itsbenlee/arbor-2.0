class AddGroupReferenceToUserStory < ActiveRecord::Migration
  def change
    add_reference :user_stories, :group, index: true
  end
end
