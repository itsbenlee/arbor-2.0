require 'csv'

class SpreadsheetExporterService
  def self.export(project, options = { col_sep: '|' })
    CSV.generate(options) do |csv|
      csv << ['Points', 'Story Number', 'User Story']
      project.hypotheses.each do |hypothesis|
        hypothesis_row(csv, hypothesis)
      end
    end
  end

  def self.hypothesis_row(csv, hypothesis)
    csv << [nil, nil, hypothesis.description]
    hypothesis.user_stories.each do |user_story|
      user_story_row(csv, user_story)
      criteria_rows(csv, user_story.acceptance_criterions)
      criteria_rows(csv, user_story.constraints)
    end
  end

  def self.user_story_row(csv, story)
    csv << [story.estimated_points, story.story_number, story.log_description]
  end

  def self.criteria_rows(csv, criterias)
    criterias.each do |criteria|
      csv << [nil, nil, "- #{criteria.description}"]
    end
  end
end
