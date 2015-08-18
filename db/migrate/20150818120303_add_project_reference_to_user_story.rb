class AddProjectReferenceToUserStory < ActiveRecord::Migration
  def change
    add_reference :user_stories, :project, index: true
  end
end
