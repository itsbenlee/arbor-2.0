class AddSlackTokenToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slack_token, :string
  end
end
