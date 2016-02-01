class AddOwnerToTeams < ActiveRecord::Migration
  def change
    add_reference :teams, :owner, null: false, index: true
  end
end
