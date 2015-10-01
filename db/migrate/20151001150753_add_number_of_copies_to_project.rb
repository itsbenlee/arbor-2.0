class AddNumberOfCopiesToProject < ActiveRecord::Migration
  def change
    add_column :projects, :copies, :integer, default: 0
  end
end
