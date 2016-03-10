require 'spec_helper'

feature 'Log activity'do
  let!(:user) { create :user }

  background do
    ENV['ENABLE_RELOADED'] = 'true'
    sign_in user
  end

  context 'for creating projects' do
    scenario 'should log project creation' do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:project_create_event).and_return(true)

      PublicActivity.with_tracking do
        within '.projects-dashboard' do
          find('#create-project-button').click
        end
        fill_in 'project_name', with: 'Test Project'
        find('input#save-project').click
      end

      project_activities = Project.first.activities
      expect(project_activities.count).to eq 1
      expect(project_activities.first.key).to eq 'project.create_project'
    end

    scenario 'should not create logs when the save fails' do
      PublicActivity.with_tracking do
        within '.projects-dashboard' do
          find('.button').click
        end
        find('input#save-project').click
      end

      expect(PublicActivity::Activity.all).to be_empty
    end
  end

  context 'for an existing project' do
    let!(:project)         { create :project, owner: user }

    background do
      visit arbor_reloaded_project_path(project)
    end

    scenario 'should show the Activity link on the sidebar to access the log' do
      within '.secondary-nav' do
        expect(page).to have_link 'Activity'
      end
    end

    scenario 'should display the log after following the link' do
      within '.secondary-nav' do
        click_link 'Activity'
      end

      expect(current_path).to eq("/arbor_reloaded/projects/#{project.id}/log")
    end

    context 'user stories' do
      let(:user_story)  { build :user_story }

      background do
        visit project_user_stories_path project
      end

      scenario 'should log adding user stories' do
        visit current_path

        within 'form.new_user_story' do
          fill_in :user_story_role, with: user_story.role
          fill_in :user_story_action, with: user_story.action
          fill_in :user_story_result, with: user_story.result

          PublicActivity.with_tracking do
            click_button 'Save'
          end
        end

        activity_keys = PublicActivity::Activity.pluck(:key)
        expect(activity_keys).to include 'project.add_user_story'
      end
    end
  end
end
