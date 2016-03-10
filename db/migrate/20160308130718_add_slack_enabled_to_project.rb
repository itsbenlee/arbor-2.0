class AddSlackEnabledToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slack_enabled, :boolean
  end
end
