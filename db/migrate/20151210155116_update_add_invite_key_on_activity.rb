class UpdateAddInviteKeyOnActivity < ActiveRecord::Migration
  def change
    PublicActivity::Activity.where(key: 'project.add_invite').each do |activity|
      activity.update_attribute(:key, 'project.add_member')
    end
  end
end
