require 'spec_helper'

feature 'Log activity' do
  let!(:user) { create :user }

  background do
    sign_in user
    visit projects_path
  end

  context 'for creating projects' do
    scenario 'should log project creation' do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:project_create_event).and_return(true)

      PublicActivity.with_tracking do
        within '.content-general' do
          click_link 'Create new project'
        end
        fill_in 'project_name', with: 'Test Project'
        find('.create-project-btn').click
      end

      project_activities = Project.first.activities
      expect(project_activities.count).to eq 1
      expect(project_activities.first.key).to eq 'project.create_project'
    end

    scenario 'should not create logs when the save fails' do
      PublicActivity.with_tracking do
        within '.content-general' do
          click_link 'Create new project'
        end
        find('.create-project-btn').click
      end

      expect(PublicActivity::Activity.all).to be_empty
    end
  end

  context 'for an existing project' do
    let!(:project)         { create :project, owner: user }

    background do
      visit project_path(project)
    end

    scenario 'should show the Activity link on the sidebar to access the log' do
      within '#sidebar' do
        expect(page).to have_link 'Activity'
      end
    end

    scenario 'should display the log after following the link' do
      within '#sidebar' do
        click_link 'Activity'
      end

      expect(page).to have_css('#log')
    end

    context 'user stories' do
      let!(:hypothesis) { create :hypothesis, project: project }
      let(:user_story)  { build :user_story }

      background do
        visit project_hypotheses_path project
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
