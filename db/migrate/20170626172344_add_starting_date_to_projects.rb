class AddStartingDateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :starting_date, :date
  end
end
