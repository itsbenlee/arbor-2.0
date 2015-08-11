class CreateMembersProjects < ActiveRecord::Migration
  def change
    create_table :members_projects do |t|
      t.references :member, null: false, index: true
      t.references :project, null: false, index: true
    end
  end
end
