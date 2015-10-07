class AddProjectToTags < ActiveRecord::Migration
  def change
    add_reference :tags, :project, index: true, foreign_key: true
  end
end
