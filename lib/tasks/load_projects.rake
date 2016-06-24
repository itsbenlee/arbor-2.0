task load_projects: :environment do
  backlogs_path = "#{File.join(Rails.root, 'lib', 'data', 'backlogs')}/*.json"

  backlogs_hash =
    Dir[backlogs_path].map { |file| JSON.parse File.read(file) }.flatten

  backlogs_hash.each do |backlog_hash|
    new_user = User.from_hash(backlog_hash)

    backlog_hash['projects'].each do |project|
      new_project = Project.from_hash(project, new_user)

      project['user_stories'].each do |story|
         new_story = UserStory.from_hash(story, new_project)

         story['acceptance_criterions'].each do |criterion|
           AcceptanceCriterion.from_hash(criterion, new_story)
         end
      end
    end
  end
end
