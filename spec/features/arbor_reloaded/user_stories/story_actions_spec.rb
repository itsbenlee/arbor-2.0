require 'spec_helper'

feature 'story actions', js: true do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_storie)  { create :user_story, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'I shold be able to access the delete action' do
    within '.backlog-user-story' do
      find('.others').click
      find('.delete-story').click

      expect(page).to have_css('.deleter')
    end
  end

  scenario 'I shold be able to access the color story action' do
    within '.backlog-user-story' do
      find('.others').click
      find('.color-story').click

      expect(page).to have_css('.color-tags')
    end
  end

  scenario 'After create a new story I should be able to still access color action' do
    within 'form#new_user_story' do
      find('#role-input').set('role')
      find('#action-input').set('action')
      find('#result-input').set('result')
      find('#save-user-story').trigger('click')
    end
    wait_for_ajax

    within '.backlog-user-story' do
      find('.others').click
      find('.color-story').click

      expect(page).to have_css('.color-tags')
    end
  end

  scenario 'After create a new story I should be able to still access delete action' do
    within 'form#new_user_story' do
      find('#role-input').set('role')
      find('#action-input').set('action')
      find('#result-input').set('result')
      find('#save-user-story').trigger('click')
    end
    wait_for_ajax

    within '.backlog-user-story' do
      find('.others').click
      find('.delete-story').click

      expect(page).to have_css('.deleter')
    end
  end
end
