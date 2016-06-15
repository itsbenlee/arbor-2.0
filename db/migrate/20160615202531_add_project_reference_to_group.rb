class AddProjectReferenceToGroup < ActiveRecord::Migration
  def change
    add_reference :groups, :project, index: true
  end
end
