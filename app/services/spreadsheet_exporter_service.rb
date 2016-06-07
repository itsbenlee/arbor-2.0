require 'csv'

class SpreadsheetExporterService
  def self.export(project, options = { col_sep: '|' })
    CSV.generate(options) do |csv|
      csv << ['Points', 'Story Number', 'User Story']
      project.user_stories.each do |user_story|
        user_story_row(csv, user_story)
      end
    end
  end

  def self.user_story_row(csv, story)
    csv << [story.estimated_points, story.story_number, story.log_description]
    criteria_rows(csv, story.acceptance_criterions)
  end

  def self.criteria_rows(csv, criterias)
    criterias.each do |criteria|
      csv << [nil, nil, "- #{criteria.description}"]
    end
  end
end
