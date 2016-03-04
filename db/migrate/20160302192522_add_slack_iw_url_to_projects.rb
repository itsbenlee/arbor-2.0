class AddSlackIwUrlToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :slack_iw_url, :string
  end
end
