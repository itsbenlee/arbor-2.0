class AddSlackIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :slack_id, :string, index: true
  end
end
