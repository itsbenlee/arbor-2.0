class UpdateOwnerAsMember < ActiveRecord::Migration
  def change
    Project.all.each(&:touch)
  end
end
