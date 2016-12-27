class AddOrderToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :order, :integer
    add_index :groups, :order
  end
end
