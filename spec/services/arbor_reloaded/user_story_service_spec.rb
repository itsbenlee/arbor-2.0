require 'spec_helper'
module ArborReloaded
  feature 'update user story' do
    let(:project)       { create :project }
    let(:story_service) { ArborReloaded::UserStoryService.new(project) }
    let(:user_story)    { create :user_story }

    scenario 'should load the response' do
      response = story_service.update_user_story(user_story)
      expect(response.success).to eq(true)
      expect(response.data[:estimated_points]).to eq(user_story.estimated_points)
      expect(response.data[:id]).to eq(user_story.id)
    end
  end

  feature 'create user story' do
    let(:user)              { create :user }
    let(:project)           { create :project, owner: user }
    let(:story_service)     { ArborReloaded::UserStoryService.new(project) }
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
      story = story_service.new_user_story(user_story_params, user)
      expect(story.success).to be(true)
      expect(story.data[:user_story_id]).to eq(UserStory.last.id)
    end

    scenario 'should create a User Story and assign the project' do
      response = story_service.new_user_story(user_story_params, user)
      expect(response.success).to be(true)
      story = UserStory.find(response.data[:user_story_id])
      expect(story).to be_a(UserStory)
      expect(story.project).to eq(project)
      expect(story.role).to eq(user_story_params[:role])
      expect(story.action).to eq(user_story_params[:action])
      expect(story.result).to eq(user_story_params[:result])
      expect(story.estimated_points).to eq(user_story_params[:estimated_points])
      expect(story.priority).to eq(user_story_params[:priority])
    end

    scenario 'should create a User Story' do
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
  end

  feature 'copy user story in other project' do
    let(:project) { create :project }
    let(:another_project)     { create :project }
    let(:user_stories)     { create_list :user_story,
                                          3,
                                          project: project }

    background do
      user_story_services = ArborReloaded::UserStoryService.new(another_project)
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

  feature 'destroy user story' do
    let(:project)       { create :project }
    let(:story_service) { ArborReloaded::UserStoryService.new(project) }
    let(:user_story)    { create :user_story }

    scenario 'should load the response' do
      response = story_service.destroy_stories(user_story)
      expect(response.success).to eq(true)
    end
  end
end
