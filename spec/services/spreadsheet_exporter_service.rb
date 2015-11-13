require 'spec_helper'

describe SpreadsheetExporterService do
  it 'should return a csv file separated by pipes' do
    project = create :project
    expect(SpreadsheetExporterService.export(project))
      .to match("Points|Story Number|User Story")
  end

  it 'should include the hypothesis' do
    hypothesis = create :hypothesis, description: 'My New hypothesis'
    project = create :project, hypotheses: [hypothesis]
    expect(SpreadsheetExporterService.export(project))
      .to match('||My New hypothesis')
  end

  it 'should include the user stories' do
    hypothesis = create :hypothesis, description: 'My New hypothesis'
    user_story = create :user_story, hypothesis: hypothesis
    project = create :project, hypotheses: [hypothesis]
    expect(SpreadsheetExporterService.export(project))
      .to match('2|1|As a/an User I should be able to')
  end

  it 'should include the constraints and acceptance criterions' do
    hypothesis = create :hypothesis, description: 'My New hypothesis'
    ac = create :acceptance_criterion, description: 'Given that I do this'
    constraint = create :constraint, description: 'You cant do this'
    user_story = create :user_story, hypothesis: hypothesis,
      acceptance_criterions: [ac], constraints: [constraint]
    project = create :project, hypotheses: [hypothesis]
    expect(SpreadsheetExporterService.export(project))
      .to match('||- Given that I do this')
    expect(SpreadsheetExporterService.export(project))
      .to match('||- You cant do this')
  end
end
