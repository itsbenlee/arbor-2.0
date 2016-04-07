class AddSlackEnabledToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slack_enabled, :boolean, default: false
  end
end
