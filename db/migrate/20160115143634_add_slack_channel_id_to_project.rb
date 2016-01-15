class AddSlackChannelIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slack_channel_id, :string
  end
end
