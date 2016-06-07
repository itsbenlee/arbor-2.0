require 'spec_helper'

describe SpreadsheetExporterService do
  it 'should return a csv file separated by pipes' do
    project = create :project
    expect(SpreadsheetExporterService.export(project))
      .to match("Points|Story Number|User Story")
  end

  it 'should include the user stories' do
    user_story = create :user_story
    project = create :project, user_stories: [user_story]
    expect(SpreadsheetExporterService.export(project))
      .to match('2|1|As a/an User I should be able to')
  end

  it 'should include the acceptance criterions' do
    ac = create :acceptance_criterion, description: 'Given that I do this'
    user_story = create :user_story, acceptance_criterions: [ac]
    project = create :project
    expect(SpreadsheetExporterService.export(project))
      .to match('||- Given that I do this')
  end
end
