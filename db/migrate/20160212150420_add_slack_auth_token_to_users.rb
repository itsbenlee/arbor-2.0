class AddSlackAuthTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :slack_auth_token, :string
  end
end
