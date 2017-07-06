require 'spec_helper'

feature 'show user stories by sprint on release plan page' do
  let(:owner)   { create :user }
  let(:project) { create :project, owner: owner }
  let(:group)   { create :group, project: project }

  let(:ungrouped_stories) do
    create_list(
      :user_story,
      3,
      project: project,
      role: Faker::Lorem.sentence,
      action: Faker::Lorem.sentence,
      result: Faker::Lorem.sentence
    )
  end

  let(:grouped_stories) do
    create_list(
      :user_story,
      3,
      project: project,
      role: Faker::Lorem.sentence,
      action: Faker::Lorem.sentence,
      result: Faker::Lorem.sentence
    )
  end

  context 'ungrouped user stories' do
    background do
      ungrouped_stories

      sign_in owner
      visit release_plan_arbor_reloaded_project_path(project.id)
    end

    scenario 'should show the ungrouped title' do
      within '.release-plan' do
        expect(page).to have_content 'Ungrouped user stories'
      end
    end

    scenario 'should show the ungrouped user stories' do
      within '.release-plan' do
        ungrouped_stories.each do |user_story|
          expect(page).to have_selector "#group-user-story-#{user_story.id}"
        end
      end
    end
  end

  context 'grouped user stories' do
    background do
      group.user_stories << grouped_stories

      sign_in owner
      visit release_plan_arbor_reloaded_project_path(project.id)
    end

    scenario 'should show the group title' do
      within '.release-plan' do
        expect(page).to have_content group.name
      end
    end

    scenario 'should show the grouped user stories' do
      within '.release-plan' do
        grouped_stories.each do |user_story|
          expect(page).to have_selector "#group-user-story-#{user_story.id}"
        end
      end
    end
  end
end
