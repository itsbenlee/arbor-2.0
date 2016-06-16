require 'spec_helper'

feature 'Create user story', js: true do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }
  let(:role)     { Faker::Lorem.word }
  let(:action)   { Faker::Lorem.word }
  let(:result)   { Faker::Lorem.word }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'should shown the user story form' do
    expect(page).to have_css 'form#new_user_story'
  end

  scenario 'should create the story on database with the correct role' do
    within 'form#new_user_story' do
      find('#role-input').set(role)
      find('#action-input').set(action)
      find('#result-input').set(result)
      find('#save-user-story').click
    end
    wait_for_ajax

    expect(UserStory.last.role).to eq(role)
  end

  scenario 'should create the story on database with the correct action' do
    within 'form#new_user_story' do
      find('#role-input').set(role)
      find('#action-input').set(action)
      find('#result-input').set(result)
      find('#save-user-story').click
    end
    wait_for_ajax

    expect(UserStory.last.action).to eq(action)
  end

  scenario 'should create the story on database with the correct result' do
    within 'form#new_user_story' do
      find('#role-input').set(role)
      find('#action-input').set(action)
      find('#result-input').set(result)
      find('#save-user-story').click
    end
    wait_for_ajax

    expect(UserStory.last.result).to eq(result)
  end
end
