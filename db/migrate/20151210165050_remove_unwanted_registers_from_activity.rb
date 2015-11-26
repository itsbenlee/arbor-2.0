class RemoveUnwantedRegistersFromActivity < ActiveRecord::Migration
  def change
    PublicActivity::Activity.where.not(key: ['project.create_project','project.add_member','project.add_user_story','project.add_comment']).destroy_all
  end
end
