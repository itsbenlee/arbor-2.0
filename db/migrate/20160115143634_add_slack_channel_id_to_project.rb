class AddSlackChannelIdToProject < ActiveRecord::Migration
  def change
    add_column :projects, :slack_channel_id, :string, index: true
  end
end
