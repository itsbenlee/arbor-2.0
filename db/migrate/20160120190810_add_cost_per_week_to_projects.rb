class AddCostPerWeekToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :cost_per_week, :integer
  end
end
