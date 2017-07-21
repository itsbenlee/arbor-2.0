class Project < ActiveRecord::Base
end

class UpdateOldProjectDataCreateDefaultSprints < ActiveRecord::Migration
  def change
    Project.all.each(&:sprints_based_on_velocity)
  end
end
