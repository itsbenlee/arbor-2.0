class AddTeamToInvites < ActiveRecord::Migration
  def change
    add_reference :invites, :team, index: true, foreign_key: true
  end
end
