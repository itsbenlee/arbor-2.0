class Project < ActiveRecord::Base
end

class UpdateOldProjectDataCreateDefaultSprints < ActiveRecord::Migration
  def change
    Project.all.each(&:create_default_sprints)
  end
end
