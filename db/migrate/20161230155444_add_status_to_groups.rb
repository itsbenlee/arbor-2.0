class AddStatusToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :status, :integer, default: 0
    add_index :groups, :status
  end
end
