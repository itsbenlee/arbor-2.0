class UpdateCostPerWeek < ActiveRecord::Migration
  def up
    change_column :projects, :cost_per_week, :numeric, scale: 0
  end

  def down
    change_column :projects, :cost_per_week, :integer, limit: 8
  end
end
