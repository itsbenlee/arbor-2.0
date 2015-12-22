require 'spec_helper'

feature 'update user story' do
  let(:project)       { create :project }
  let(:story_service) { UserStoryService.new(project) }
  let(:user_story)    {
    create :user_story,
    role: 'User',
    action: 'be able to reset my password',
    result: 'so that I can recover my account',
    estimated_points: 1,
    priority: 'should'
  }

  scenario 'should load the response' do
    response = story_service.update_user_story(user_story)
    expect(response.success).to eq(true)
    expect(response.data[:edit_url]).to eq(edit_user_story_path(user_story))
  end
end

feature 'create user story' do
  let(:user)              { create :user }
  let(:project)           { create :project, owner: user }
  let(:hypothesis)        { create :hypothesis, project: project }
  let(:story_service)     { UserStoryService.new(project, hypothesis) }
  let(:user_story_params) {
    {
      role: 'User',
      action: 'be able to reset my password',
      result: 'so that I can recover my account',
      estimated_points: 1,
      priority: 'should'
    }
  }

  scenario 'for Arbor Reloaded, should create and return it' do
    story = story_service.create_user_story(user_story_params, user)
    expect(story).to be_a(UserStory)
    expect(story.project).to eq(project)
    expect(story.role).to eq(user_story_params[:role])
    expect(story.action).to eq(user_story_params[:action])
    expect(story.result).to eq(user_story_params[:result])
  end

  scenario 'should create a User Story and assign the project' do
    response = story_service.new_user_story(user_story_params, user)
    expect(response.success).to eq(true)
    story = UserStory.find(response.data[:user_story_id])
    expect(story).to be_a(UserStory)
    expect(story.project).to eq(project)
    expect(story.role).to eq(user_story_params[:role])
    expect(story.action).to eq(user_story_params[:action])
    expect(story.result).to eq(user_story_params[:result])
    expect(story.estimated_points).to eq(user_story_params[:estimated_points])
    expect(story.priority).to eq(user_story_params[:priority])
  end

  scenario 'should create a User Story and assign the project and hypothesis' do
    response = story_service.new_user_story(user_story_params, user)
    expect(response.success).to eq(true)
    story = UserStory.find(response.data[:user_story_id])
    expect(story).to be_a(UserStory)
    expect(story.project).to eq(project)
    expect(story.hypothesis).to eq(hypothesis)
    expect(story.role).to eq(user_story_params[:role])
    expect(story.action).to eq(user_story_params[:action])
    expect(story.result).to eq(user_story_params[:result])
    expect(story.estimated_points).to eq(user_story_params[:estimated_points])
    expect(story.priority).to eq(user_story_params[:priority])
  end
end

feature 'copy user story in other project' do
  let(:project) { create :project }
  let(:another_project)     { create :project }
  let(:user_stories)     { create_list :user_story,
                                        3,
                                        project: project }

  background do
    user_story_services = UserStoryService.new(another_project)
    user_story_services.copy_stories(user_stories)
    another_project.user_stories.reload
  end

  scenario 'user stories amount is the same in both projects' do
    expect(another_project.user_stories.count).to eq(3)
  end

  scenario 'user story data is copied successfully' do
    user_stories.each_with_index do |user_story, index|
      expect(another_project.user_stories[index].role).to eq(user_story.role)
      expect(another_project.user_stories[index].action).to eq(user_story.action)
      expect(another_project.user_stories[index].result).to eq(user_story.result)
      expect(another_project.user_stories[index].priority).to eq(user_story.priority)
      expect(another_project.user_stories[index].estimated_points).to eq(user_story.estimated_points)
    end
  end

  scenario 'should reorder acceptance criterions on user story' do
    user_story = create :user_story
    first_criterion, second_criterion, third_criterion = create_list :acceptance_criterion, 3, user_story: user_story
    criterions = { 'criterions' => {
                      '0' => {'id' => first_criterion.id, 'criterion_order' => 2},
                      '1' => {'id' => second_criterion.id, 'criterion_order' => 3},
                      '2' => {'id' => third_criterion.id, 'criterion_order' => 1}
                    }
                  }

    acceptance_criterion_service = AcceptanceCriterionServices.new(user_story)
    acceptance_criterion_service.reorder_criterions(criterions)

    first_criterion_updated, second_criterion_updated, third_criterion_updated =
    AcceptanceCriterion.find(first_criterion.id, second_criterion.id, third_criterion.id)

    expect(first_criterion_updated.order).to eq 2
    expect(second_criterion_updated.order).to eq 3
    expect(third_criterion_updated.order).to eq 1
  end

  scenario 'should reorder constraints on user story' do
    user_story = create :user_story
    first_constraint, second_constraint, third_constraint = create_list :constraint, 3, user_story: user_story
    constraints = { 'constraints' => {
                      '0' => {'id' => first_constraint.id, 'constraint_order' => 2},
                      '1' => {'id' => second_constraint.id, 'constraint_order' => 3},
                      '2' => {'id' => third_constraint.id, 'constraint_order' => 1}
                    }
                  }

    constraints_services = ConstraintServices.new(user_story)
    constraints_services.reorder_constraints(constraints)

    first_constraint_updated, second_constraint_updated, third_constraint_updated =
    Constraint.find(first_constraint.id, second_constraint.id, third_constraint.id)

    expect(first_constraint_updated.order).to eq 2
    expect(second_constraint_updated.order).to eq 3
    expect(third_constraint_updated.order).to eq 1
  end
end
