require 'spec_helper'

feature 'Groups', js: true do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }
  let!(:group)   { create :group, project: project }

  context 'For creating groups' do
    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project)
    end

    scenario 'I should see the create group on the backlog section' do
      within '.backlog-story-list' do
        expect(page).to have_css('#create-group')
      end
    end

    scenario 'I should be able to create a group' do
      within '.backlog-story-list' do
        find('#create-group').click
      end

      within 'form#new_group' do
        fill_in 'group_name', with: 'Test group'
        click_button 'Create'
      end
      wait_for_ajax

      group = Group.find_by_name('Test group')
      expect(group.project).to eq(project)
    end

    scenario 'I should see a group after creating it' do
      within '.backlog-story-list' do
        find('#create-group').click
      end

      within 'form#new_group' do
        fill_in 'group_name', with: 'Test group'
        click_button 'Create'
      end
      wait_for_ajax
      expect(page).to have_content(/Test group/i)
    end

    scenario 'I should see the group on select box after creating it' do
      within '.backlog-story-list' do
        find('#create-group').click
      end

      within 'form#new_group' do
        fill_in 'group_name', with: 'Test group'
        click_button 'Create'
      end
      wait_for_ajax
      sleep 0.5

      expect(find('#user_story_group_id').find(:xpath, 'option[3]').text).to eq('Test group')
    end

    scenario 'I should see the error message wen name is taken' do
      within '.backlog-story-list' do
        find('#create-group').click
      end

      within 'form#new_group' do
        fill_in 'group_name', with: group.name
        click_button 'Create'
      end
      wait_for_ajax

      expect(page).to have_content('Name has already been taken')
    end
  end

  context 'For listing groups' do
    let!(:group) { create :group, project: project }

    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project)
    end

    scenario 'I should see existing groups' do
      expect(page).to have_content(group.name.upcase)
    end
  end

  context 'For deleting grups' do
    let!(:group)      { create :group, project: project }
    let!(:user_story) { create :user_story, project: project, group: group }

    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project)
    end

    scenario 'I should see the delete group button' do
      within "#group-#{group.id}" do
        expect(page).to have_css('.delete-group')
      end
    end
  end
end
