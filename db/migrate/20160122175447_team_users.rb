class TeamUsers < ActiveRecord::Migration
  def change
    create_table :team_users do |t|
      t.references :team, null: false, index: true, foreign_key: true
      t.references :user, null: false, index: true, foreign_key: true
    end
  end
end
