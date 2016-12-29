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
        expect(page).to have_css('.add-new-group')
      end
    end

    scenario 'I should be able to create a group' do
      within '.backlog-story-list' do
        find('#add-new-group-bottom h5').trigger 'click'
      end

      within '#add-new-group-bottom form#new_group' do
        fill_in 'group_name', with: 'Test group'
        page.execute_script("$('#add-new-group-bottom form#new_group').submit()")
      end
      wait_for_ajax

      group = Group.find_by_name('Test group')
      expect(group.project).to eq(project)
    end

    scenario 'I should see a group after creating it' do
      within '.backlog-story-list' do
        find('#add-new-group-bottom h5').trigger 'click'
      end

      within '#add-new-group-bottom form#new_group' do
        fill_in 'group_name', with: 'Test group'
        page.execute_script("$('#add-new-group-bottom form#new_group').submit()")
      end
      wait_for_ajax
      expect(page).to have_content(/Test group/i)
    end

    scenario 'I should see the group on select box after creating it' do
      within '.backlog-story-list' do
        find('#add-new-group-bottom h5').trigger 'click'
      end

      within '#add-new-group-bottom form#new_group' do
        fill_in 'group_name', with: 'Test group'
        page.execute_script("$('#add-new-group-bottom form#new_group').submit()")
      end
      wait_for_ajax
      sleep 0.5

      expect(find('#user_story_group_id').find(:xpath, 'option[3]').text).to eq('Test group')
    end

    scenario 'I should see the error message when name is taken' do
      within '.backlog-story-list' do
        find('#add-new-group-bottom h5').trigger 'click'
      end

      within '#add-new-group-bottom form#new_group' do
        fill_in 'group_name', with: group.name
        page.execute_script("$('#add-new-group-bottom #new_group').submit()")
      end
      wait_for_ajax

      page.execute_script("$('#add-new-group-bottom .new-group-container').removeClass('hidden-element')")
      expect(find("#add-new-group-bottom #new_group")).to have_css(".errors")
    end

    scenario 'I should see the error message when name is longer than 100 characters' do
      within '.backlog-story-list' do
        find('#add-new-group-bottom h5').trigger 'click'
      end

      within '#add-new-group-bottom form#new_group' do
        fill_in 'group_name', with: "Test group"*11
        page.execute_script("$('#add-new-group-bottom #new_group').submit()")
      end
      wait_for_ajax

      page.execute_script("$('#add-new-group-bottom .new-group-container').removeClass('hidden-element')")
      expect(find("#add-new-group-bottom #new_group")).to have_css(".errors")
    end

    context 'On the upper new group form' do
      let!(:user_story) { create :user_story, project: project }

      scenario 'I should be able to create a group that has all the ungrouped stories' do
        within '.backlog-story-list' do
          find('#add-new-group-upper h5').trigger 'click'
        end

        within '#add-new-group-upper form#new_group' do
          fill_in 'group_name', with: "Test group"
          page.execute_script("$('#add-new-group-upper #new_group').submit()")
        end
        wait_for_ajax

        group = Group.find_by_name('Test group')
        expect(group.user_stories).to include(user_story)
      end

      scenario 'I should make the project not have any ungrouped story' do
        within '.backlog-story-list' do
          find('#add-new-group-upper h5').trigger 'click'
        end

        within '#add-new-group-upper form#new_group' do
          fill_in 'group_name', with: "Test group"
          page.execute_script("$('#add-new-group-upper #new_group').submit()")
        end
        wait_for_ajax

        expect(project.ungrouped_user_stories?).to be false
      end
    end
  end

  context 'For listing groups' do
    let!(:group)    { create :group, project: project }

    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project)
    end

    scenario 'I should see existing groups' do
      expect(page).to have_content(group.name.upcase)
    end
  end

  context 'Editing group' do
    let!(:first_group)  { create :group, project: project }
    let!(:second_group) { create :group, project: project }

    background do
      sign_in user
      visit arbor_reloaded_project_user_stories_path(project)
    end

    scenario 'I should be able to change the group\'s name' do
      within "#group-#{first_group.id}" do
        find('h5').click
      end

      within "form#edit_group_#{first_group.id}" do
        fill_in 'group_name', with: 'New name'
        page.execute_script("$('form#edit_group_#{first_group.id}').submit()")
      end

      wait_for_ajax
      expect(page).to have_content('New name'.upcase)
    end

    scenario 'I should see the original group\'s name if it is repeated' do
      within "#group-#{first_group.id}" do
        find('h5').click
      end

      within "form#edit_group_#{first_group.id}" do
        fill_in 'group_name', with: second_group.name
        page.execute_script("$('form#edit_group_#{first_group.id}').submit()")
      end

      wait_for_ajax
      expect(page).to have_content(first_group.name.upcase)
    end

    scenario 'I should see the original group\'s name if it is too long' do
      within "#group-#{first_group.id}" do
        find('h5').click
      end

      within "form#edit_group_#{first_group.id}" do
        fill_in 'group_name', with: 'More than 100 characters' * 5
        page.execute_script("$('form#edit_group_#{first_group.id}').submit()")
      end

      wait_for_ajax
      expect(page).to have_content(first_group.name.upcase)
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
