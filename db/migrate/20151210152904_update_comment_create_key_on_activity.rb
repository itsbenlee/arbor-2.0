class UpdateCommentCreateKeyOnActivity < ActiveRecord::Migration
  def change
    PublicActivity::Activity.where(key: 'user_story.add_comment').each do |activity|
      activity.update_attribute(:key, 'project.add_comment')
      activity.update_attribute(:trackable_type, 'Project')
      story = UserStory.find(activity.trackable_id)
      activity.update_attribute(:trackable_id, story.project.id)
    end
  end
end
