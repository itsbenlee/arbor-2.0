class AddOrderToConstraint < ActiveRecord::Migration
  def change
    add_column :constraints, :order, :integer, index: true
  end

  def data
    i = 1
    Constraint.all.order(created_at: :asc).each do |constraint|
      constraint.order = i
      constraint.save
      i += 1
    end
  end
end
