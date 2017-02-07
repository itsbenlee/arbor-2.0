require 'spec_helper'

feature 'Create user story', js: true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let(:role)        { Faker::Lorem.word }
  let(:action)      { Faker::Lorem.word }
  let(:result)      { Faker::Lorem.word }
  let(:description) { Faker::Lorem.word }
  let!(:group)      { create :group, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
    find('.show-updates-popup').click
  end

  scenario 'should show control for switching mode' do
    expect(page).to have_css '.backlog-story-creation-mode'
  end

  context 'switching to freeform flow' do
    before do
      within '.backlog-story-creation-mode' do
        find('.creation-mode-icon').click
        find('.creation-mode-freeform').click
      end
    end

    scenario 'should show the freeform user story form' do
      expect(page).to have_css'form#new_free_user_story'
    end


    scenario 'should create the story on database with the correct description' do
      within 'form#new_free_user_story' do
        find('#description-input').set(description)
        find('.save-user-story').click
      end
      wait_for_ajax

      expect(UserStory.last.description).to eq(description)
    end
  end

  context 'switching to guided flow' do
    before do
      within '.backlog-story-creation-mode' do
        find('.creation-mode-icon').click
        find('.creation-mode-guided').click
      end
    end

    scenario 'should shown the user story form' do
      expect(page).to have_css'form#new_user_story'
    end

    scenario 'should create the story on database with the correct role' do
      within 'form#new_user_story' do
        find('#role-input').set(role)
        find('#action-input').set(action)
        find('#result-input').set(result)
        find('.save-user-story').click
      end
      wait_for_ajax

      expect(UserStory.last.role).to eq(role)
    end

    scenario 'should create the story on database with the correct action' do
      within 'form#new_user_story' do
        find('#role-input').set(role)
        find('#action-input').set(action)
        find('#result-input').set(result)
        find('.save-user-story').click
      end
      wait_for_ajax

      expect(UserStory.last.action).to eq(action)
    end

    scenario 'should create the story on database with the correct result' do
      within 'form#new_user_story' do
        find('#role-input').set(role)
        find('#action-input').set(action)
        find('#result-input').set(result)
        find('.save-user-story').click
      end
      wait_for_ajax

      expect(UserStory.last.result).to eq(result)
    end

    scenario 'I should be able to see the group select' do
      within '#new_user_story' do
        expect(page).to have_css('#user_story_group_id')
      end
    end

    scenario 'I should be able to assign the group on top to the new story' do
      within 'form#new_user_story' do
        find('#role-input').set(role)
        find('#action-input').set(action)
        find('#result-input').set(result)
        find('#user_story_group_id').find("option[value='#{group.id}']").select_option
        find('.save-user-story').click
      end
      wait_for_ajax

      expect(UserStory.last.group).to eq(group)
    end

    context 'when writing the new story' do
      scenario 'I should see the button on green when all fields contain characters' do
        within 'form#new_user_story' do
          fill_in 'role-input', with: 'user'
          fill_in 'action-input', with: 'I want to see the button with green color when creating stories'
          fill_in 'result-input', with: 'I know when they are ready to submit'

          expect(page).to have_css('.save-user-story.complete')
        end
      end

      scenario 'I should not see the button on green if any field lacks of content' do
        within 'form#new_user_story' do
          fill_in 'role-input', with: 'user'
          fill_in 'action-input', with: 'I should not see the button with green color'

          expect(page).not_to have_css('.save-user-story.complete')
        end
      end
    end
  end

  context 'when navingating on project\'s backlog page' do
    scenario 'I should be able to see the user story\'s creation bar fixed' do
      add_height = "$('html').height($(window).height() + $('.new-backlog-story').offset().top)"
      scroll_to_story_bar = "$(window).scrollTop($('.new-backlog-story').offset().top)"

      page.execute_script(add_height)
      page.execute_script(scroll_to_story_bar)
      expect(page).to have_css('.user-story-form-container.fixed')
    end

    scenario 'I should not see user\'s story creation bar fixed if the user is on top' do
      page.execute_script('$(window).scrollTop(0)')
      expect(page).not_to have_css('.user-story-form-container.fixed')
    end
  end
end
