class UpdateProjectCreateKeyOnActivity < ActiveRecord::Migration
  def change
    PublicActivity::Activity.where(key: 'project.create').each do |activity|
      activity.update_attribute(:key, 'project.create_project')
    end
  end
end
