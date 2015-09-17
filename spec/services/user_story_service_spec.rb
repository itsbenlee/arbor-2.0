require 'spec_helper'
feature 'create user story' do
  let(:project)           { create :project }
  let(:story_service)     { UserStoryService.new }
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
    story = story_service.new_user_story(user_story_params, project)
    expect(story).to be_a(UserStory)
    expect(story.project).to eq(project)
    expect(story.role).to eq(user_story_params[:role])
    expect(story.action).to eq(user_story_params[:action])
    expect(story.result).to eq(user_story_params[:result])
    expect(story.estimated_points).to eq(user_story_params[:estimated_points])
    expect(story.priority).to eq(user_story_params[:priority])
    expect(story.epic).to eq(user_story_params[:epic])
  end
end