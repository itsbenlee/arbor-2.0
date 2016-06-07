class AddVelocityToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :velocity, :integer
  end
end
