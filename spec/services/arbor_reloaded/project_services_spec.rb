require 'spec_helper'
module ArborReloaded
  feature 'update project' do
    let(:project)         { create :project }
    let(:project_service) { ArborReloaded::ProjectServices.new(project) }

    scenario 'should load the response with the projects list url' do
      response = project_service.update_project
      route_helper = Rails.application.routes.url_helpers

      expect(response.success).to eq(true)
      expect(response.data[:return_url]).to eq(route_helper.arbor_reloaded_projects_list_path)
    end
  end

  feature 'Reorder stories' do
    let!(:user)    { create :user }
    let!(:project) { create :project, owner: user }

    background do
      sign_in user
    end

    scenario 'should reorder user stories' do
      first_story, second_story, third_story = set_user_stories_on_project(project)
      stories = { '0' => {'id' => first_story.id, 'backlog_order' => 2},
                  '1' => {'id' => second_story.id, 'backlog_order' => 3},
                  '2' => {'id' => third_story.id, 'backlog_order' => 1} }

      project_services = ArborReloaded::ProjectServices.new(project)
      project_services.reorder_stories(stories)

      first_story_updated, second_story_updated, third_story_updated =
      get_reordered(first_story, second_story, third_story)

      expect(first_story_updated.backlog_order).to eq 2
      expect(second_story_updated.backlog_order).to eq 3
      expect(third_story_updated.backlog_order).to eq 1
    end
  end

  feature 'Copy project' do
    let!(:user)             { create :user }
    let!(:project)          { create :project, owner: user }
    let!(:project_services) { ArborReloaded::ProjectServices.new(project) }

    background do
      sign_in user
    end

    scenario 'should update number of copies' do
      user_story = create :user_story, project: project, hypothesis: nil
      project_services.replicate(user)
      project.reload
      expect(project.copies).to eq(1)
    end

    scenario 'should copy all the stories' do
      create_list :user_story, 3, project: project, hypothesis: nil
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories.count).to eq(3)
    end

    scenario 'should copy correct data for user stories' do
      user_story = create :user_story, project: project
      response = project_services.replicate(user)

      copied_story = response.data[:project].user_stories[0]

      expect(user_story.role).to eq(copied_story.role)
      expect(user_story.action).to eq(copied_story.action)
      expect(user_story.result).to eq(copied_story.result)
      expect(user_story.estimated_points).to eq(copied_story.estimated_points)
      expect(user_story.priority).to eq(copied_story.priority)
    end

    scenario 'should copy the criterions' do
      user_story = create :user_story, project: project
      acceptance_criterion =
        create :acceptance_criterion, { user_story: user_story }

      response = project_services.replicate(user)

      copied_criterion =
        response.data[:project].user_stories[0].acceptance_criterions[0]
      expect(acceptance_criterion.description).to eq(copied_criterion.description)
    end

    scenario 'should copy all the criterions' do
      user_story = create :user_story, project: project
      create_list :acceptance_criterion, 3, user_story: user_story

      project_services = ProjectServices.new(project)
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories[0].acceptance_criterions.count).to eq(3)
    end

    scenario 'should copy all the constraints' do
      user_story = create :user_story, project: project
      constraint = create :constraint, user_story: user_story
      response = project_services.replicate(user)

      copied_constraint =
        response.data[:project].user_stories[0].constraints[0]
      expect(constraint.description).to eq(copied_constraint.description)
    end

    scenario 'should copy all the constraints' do
      user_story = create :user_story, project: project
      create_list :constraint, 3, user_story: user_story
      response = project_services.replicate(user)

      expect(response.data[:project].user_stories[0].constraints.count).to eq(3)
    end

    scenario 'should copy canvas on a replica' do
      canvas = create :canvas, project: project
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
  end
end
