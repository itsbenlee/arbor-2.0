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
    priority: 'should',
    epic: false
  }

  scenario 'should load the response' do
    response = story_service.update_user_story(user_story)
    expect(response.success).to eq(true)
    expect(response.data[:edit_url]).to eq(edit_user_story_path(user_story))
  end
end

feature 'create user story' do
  let(:project)           { create :project }
  let(:hypothesis)        { create :hypothesis, project: project }
  let(:story_service)     { UserStoryService.new(project, hypothesis) }
  let(:user_story_params) {
    {
      role: 'User',
      action: 'be able to reset my password',
      result: 'so that I can recover my account',
      estimated_points: 1,
      priority: 'should',
      epic: false
    }
  }

  scenario 'should create a User Story and assign the project' do
    response = story_service.new_user_story(user_story_params)
    expect(response.success).to eq(true)
    story = UserStory.find(response.data[:user_story_id])
    expect(story).to be_a(UserStory)
    expect(story.project).to eq(project)
    expect(story.role).to eq(user_story_params[:role])
    expect(story.action).to eq(user_story_params[:action])
    expect(story.result).to eq(user_story_params[:result])
    expect(story.estimated_points).to eq(user_story_params[:estimated_points])
    expect(story.priority).to eq(user_story_params[:priority])
    expect(story.epic).to eq(user_story_params[:epic])
  end

  scenario 'should create a User Story and assign the project and hypothesis' do
    response = story_service.new_user_story(user_story_params)
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
    expect(story.epic).to eq(user_story_params[:epic])
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
end
