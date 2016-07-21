namespace :user_stories do
  desc 'Mantain backlog orders clean'

  task clean_backlog_orders: :environment do
    Project.all.each do |project|
      project
        .user_stories
        .order(backlog_order: :asc)
        .each_with_index do |user_story, index|
          user_story.update_attribute('backlog_order', (index + 1))
      end
    end
  end
end
