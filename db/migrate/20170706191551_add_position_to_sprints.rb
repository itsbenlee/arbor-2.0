class AddPositionToSprints < ActiveRecord::Migration
  def change
    add_column :sprints, :position, :integer
  end
end
