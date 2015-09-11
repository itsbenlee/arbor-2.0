require 'spec_helper'

def set_new_order(first_hypothesis, second_hypothesis)
  first_hypothesis_ordered = {
    id: first_hypothesis.id,
    order: 2
  }

  second_hypothesis_ordered = {
    id: second_hypothesis.id,
    order: 1
  }

  { 0 => second_hypothesis_ordered, 1 => first_hypothesis_ordered }
end

feature 'Reorder hypothesis inside' do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let(:hypothesis)   { create :hypothesis, project: project }

  background do
    sign_in user
  end

  scenario 'should use the new order for hypothesis' do
    second_hypothesis = create :hypothesis, { project: project }
    new_order = set_new_order(hypothesis, second_hypothesis)

    project_services = ProjectServices.new(project)
    project_services.reorder_hypotheses(new_order)

    updated_first_hypothesis = Hypothesis.find(hypothesis.id)
    updated_second_hypothesis = Hypothesis.find(second_hypothesis.id)
    expect(updated_first_hypothesis.order).to eq 2
    expect(updated_second_hypothesis.order).to eq 1
  end

  scenario 'should reorder user stories on project' do
    first_story, second_story, third_story = set_user_stories_on_project(project)
    stories =  { '0' => {'id' => first_story.id, 'backlog_order' => 2},
                 '1' => {'id' => second_story.id, 'backlog_order' => 3},
                 '2' => {'id' => third_story.id, 'backlog_order' => 1} }

    project_services = ProjectServices.new(project)
    project_services.reorder_stories(stories)

    first_story_updated, second_story_updated, third_story_updated =
      get_reordered(first_story, second_story, third_story)

    expect(first_story_updated.backlog_order).to eq 2
    expect(second_story_updated.backlog_order).to eq 3
    expect(third_story_updated.backlog_order).to eq 1
  end
end

feature 'Collect log entries' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  scenario 'should collect the log entries of all associated entities' do
    PublicActivity.with_tracking do
      @project = create :project
      hypothesis = create :hypothesis
      goal = create :goal
      @project.hypotheses << hypothesis
      hypothesis.goals << goal
    end

    project_services = ProjectServices.new(@project)
    log_entries = project_services.activities_by_pages.flatten

    %w(
      hypothesis.add_goal
      goal.update
      project.add_hypothesis
      hypothesis.update
      goal.create
      hypothesis.create
      project.add_member
      project.create
    ).each do |key|
      expect(log_entries.map(&:key)).to include key
    end
  end
end
