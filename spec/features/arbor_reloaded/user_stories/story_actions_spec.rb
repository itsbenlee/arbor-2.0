require 'spec_helper'

feature 'story actions', js: true do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }

  background do
    ENV['ENABLE_INTERCOM'] = 'false'
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'After create a new story I should be able to still access color action' do
    within 'form#new_user_story' do
      fill_in 'role-input', with: 'some text'
      fill_in 'action-input', with: 'some text'
      fill_in 'result-input', with: 'some text'
    end
    page.execute_script("$('form#new_user_story').submit()")
    wait_for_ajax

    within '.backlog-user-story' do
      find('.others').click
      find('.color-story').click

      expect(page).to have_css('.color-tags')
    end
  end

  scenario 'After create a new story I should be able to still access delete action' do
    within 'form#new_user_story' do
      fill_in 'role-input', with: 'some text'
      fill_in 'action-input', with: 'some text'
      fill_in 'result-input', with: 'some text'
    end
    page.execute_script("$('form#new_user_story').submit()")

    sleep 3

    within '.backlog-user-story' do
      find('.others').click
      find('.delete-story').click

      expect(page).to have_css('.deleter')
    end
  end
end
