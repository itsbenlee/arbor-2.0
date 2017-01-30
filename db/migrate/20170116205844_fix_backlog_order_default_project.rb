class FixBacklogOrderDefaultProject < ActiveRecord::Migration
  class UserStory < ActiveRecord::Base
  end

  class Project < ActiveRecord::Base
    has_many :user_stories
  end

  def change
    project = Project.where(name: 'Taxi Hailing App').first

    if project
      project.user_stories.order(:id).each_with_index do |story, index|
        story.update_column(:backlog_order, index + 1)
      end
    end
  end
end
