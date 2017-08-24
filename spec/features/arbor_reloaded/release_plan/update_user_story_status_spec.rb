require 'spec_helper'

feature 'update user story status on sprint from release plan page' do
  let(:user)        { create :user }
  let(:project)     { create :project, owner: user }
  let(:sprint)      { project.sprints.first }
  let!(:user_story) { create :user_story, project: project }

  context 'user story does not belong to sprint' do
    background do
      sign_in user

      visit release_plan_arbor_reloaded_project_path(project.id)

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end
    end

    scenario 'should add the user story in the selected sprint', js: true do
      expect(SprintUserStory.count).to eq 1
      expect(sprint.reload.user_stories.count).to eq 1
    end

    scenario 'should add the user story in the selected sprint with PLANNED as status code', js: true do
      expect(SprintUserStory.last.status).to eq 'PLANNED'
    end

    scenario 'should change the status every time you click the user story sprint cell', js: true do
      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(SprintUserStory.last.status).to eq 'WIP'

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        expect(find('a').text).to eq 'Wip'
      end

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(SprintUserStory.last.status).to eq 'ADVANCE_WORK'

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        expect(find('a').text).to eq 'Advance work'
      end

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(SprintUserStory.last.status).to eq 'DONE'

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        expect(find('a').text).to eq 'Done'
      end

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(SprintUserStory.last.status).to eq 'CARRYOVER'

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        expect(find('a').text).to eq 'Carryover'
      end

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(sprint.reload.user_stories.count).to eq 0

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end

      expect(SprintUserStory.last.status).to eq 'PLANNED'

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        expect(find('a').text).to eq 'Planned'
      end
    end
  end

  context 'user story belongs to project with CARRYOVER as status code' do
    let!(:sprint_user_story) { SprintUserStory.create(user_story: user_story, sprint: sprint, status: 'CARRYOVER') }

    background do
      sign_in user

      visit release_plan_arbor_reloaded_project_path(project.id)

      within "#user-story-#{user_story.id}-sprint-#{sprint.id}" do
        find('a').trigger(:click)
        wait_for_ajax
      end
    end

    scenario 'should remove the user story in the selected sprint', js: true do
      expect(sprint.reload.user_stories.count).to eq 0
    end
  end
end
