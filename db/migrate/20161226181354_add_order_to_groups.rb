class AddOrderToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :order, :integer
    add_index :groups, :order

    # Some groups maybe not have project because they were erased.
    Group.all.group_by(&:project_id).values.each do |project|
      order = 0
      project.each do |group|
        group.update_column(:order, order)
        order += 1
      end
    end
  end
end
