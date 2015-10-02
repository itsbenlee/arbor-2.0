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

  feature 'Replicate project' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user }

    scenario 'should update number of copies' do
      user_story = create :user_story, project: project, hypothesis: nil
      project_services = ProjectServices.new(project)
      project_services.replicate
      project.reload
      expect(project.copies).to eq(1)
    end

    scenario 'should check user stories copied' do
      create_list :user_story, 3, project: project, hypothesis: nil

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      expect(response.data[:project].user_stories.count).to eq(3)
    end

    scenario 'should copy the same data for user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      copied_story = response.data[:project].user_stories[0]

      expect(user_story.role).to eq(copied_story.role)
      expect(user_story.action).to eq(copied_story.action)
      expect(user_story.result).to eq(copied_story.result)
      expect(user_story.estimated_points).to eq(copied_story.estimated_points)
      expect(user_story.priority).to eq(copied_story.priority)
    end

    scenario 'should copy criterion on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      acceptance_criterion =
        create :acceptance_criterion, { user_story: user_story }

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      copied_criterion =
        response.data[:project].user_stories[0].acceptance_criterions[0]
      expect(acceptance_criterion.description).to eq(copied_criterion.description)
    end

    scenario 'should copy same amount of criterions on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      create_list :acceptance_criterion, 3, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      expect(response.data[:project].user_stories[0].acceptance_criterions.count).to eq(3)
    end

    scenario 'should copy constraint on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      constraint = create :constraint, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      copied_constraint =
        response.data[:project].user_stories[0].constraints[0]
      expect(constraint.description).to eq(copied_constraint.description)
    end

    scenario 'should copy same amount of constraints on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      create_list :constraint, 3, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate

      expect(response.data[:project].user_stories[0].constraints.count).to eq(3)
    end
  end
end
