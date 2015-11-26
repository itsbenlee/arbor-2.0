require 'spec_helper'

def create_complete_project
  hypothesis = create :hypothesis, project: project
  user_story = create :user_story,
                      project: project,
                      hypothesis: hypothesis
  create_list :goal, 3, hypothesis: hypothesis
  create_list :acceptance_criterion, 3, user_story: user_story
  create_list :constraint, 3, user_story: user_story
  project.reload
  hypothesis.reload
end

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
    stories = { '0' => {'id' => first_story.id, 'backlog_order' => 2},
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

feature 'Copy project' do
  let!(:user) { create :user }

  background do
    sign_in user
  end

  context 'Replicate project' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user }

    scenario 'should update number of copies' do
      user_story = create :user_story, project: project, hypothesis: nil
      project_services = ProjectServices.new(project)
      project_services.replicate(user)
      project.reload
      expect(project.copies).to eq(1)
    end

    scenario 'should check user stories copied' do
      create_list :user_story, 3, project: project, hypothesis: nil

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories.count).to eq(3)
    end

    scenario 'should copy the same data for user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

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
      response = project_services.replicate(user)

      copied_criterion =
        response.data[:project].user_stories[0].acceptance_criterions[0]
      expect(acceptance_criterion.description).to eq(copied_criterion.description)
    end

    scenario 'should copy same amount of criterions on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      create_list :acceptance_criterion, 3, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories[0].acceptance_criterions.count).to eq(3)
    end

    scenario 'should copy constraint on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      constraint = create :constraint, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      copied_constraint =
        response.data[:project].user_stories[0].constraints[0]
      expect(constraint.description).to eq(copied_constraint.description)
    end

    scenario 'should copy same amount of constraints on user stories without hypothesis' do
      user_story = create :user_story, project: project, hypothesis: nil
      create_list :constraint, 3, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories[0].constraints.count).to eq(3)
    end

    scenario 'should copy canvas on a replica' do
      canvas = create :canvas, project: project
      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)
      expect(response.data[:project].canvas.problems).to eq(canvas.problems)
      expect(response.data[:project].canvas.solutions).to eq(canvas.solutions)
      expect(response.data[:project].canvas.alternative).to eq(canvas.alternative)
      expect(response.data[:project].canvas.advantage).to eq(canvas.advantage)
      expect(response.data[:project].canvas.segment).to eq(canvas.segment)
      expect(response.data[:project].canvas.channel).to eq(canvas.channel)
      expect(response.data[:project].canvas.value_proposition).to eq(canvas.value_proposition)
      expect(response.data[:project].canvas.revenue_streams).to eq(canvas.revenue_streams)
      expect(response.data[:project].canvas.cost_structure).to eq(canvas.cost_structure)
    end

    scenario 'should copy user stories with hypothesis' do
      hypothesis = create :hypothesis, project: project
      create_list :user_story, 3, project: project, hypothesis: hypothesis
      project.reload
      hypothesis.reload
      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories.count).to eq(3)
    end

    scenario 'should copy goals' do
      hypothesis = create :hypothesis, project: project
      create_list :goal, 3, hypothesis: hypothesis
      project.reload
      hypothesis.reload
      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].hypotheses.first.goals.count).to eq(3)
    end

    scenario 'should copy user stories under hypothesis' do
      hypothesis = create :hypothesis, project: project
      stories = create_list :user_story, 3, project: project,
        hypothesis: hypothesis
      project.reload
      hypothesis.reload
      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      project_replica = response.data[:project]

      project_replica.user_stories.each_with_index do |user_story, index|
        expect(user_story.hypothesis_id).to eq(project_replica.hypotheses[0].id)
      end
    end
  end

  context 'Log activity for project replica' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user }

    background do
      PublicActivity.with_tracking do
        create_complete_project
        @project_services = ProjectServices.new(project)
      end
    end

    scenario 'should copy project and create only one activity' do
      PublicActivity.with_tracking do
        @project_services.replicate(user)
      end

      expect(Project.last.activities.count).to eq(1)
      expect(Project.last.activities[0].key).to eq('project.create_project')
    end
  end
end
