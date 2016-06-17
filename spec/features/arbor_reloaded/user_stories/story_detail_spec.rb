require 'spec_helper'

feature 'Story detail modal', js:true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:group)      { create :group, project: project }
  let!(:user_story) { create :user_story, project: project, estimated_points: 1 }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
    find('.story-detail-link').click
  end

  scenario 'should display the details modal' do
    expect(page).to have_css('#story-detail-modal')
  end

  scenario 'should be able to estimate a story' do
    find('#fibonacci-dropdown').find('option[value="13"]').select_option
    wait_for_ajax
    user_story.reload
    expect(user_story.estimated_points).to eq(13)
  end

  scenario 'the estimation includes the first 7 fibonacci numbers' do
    options = find('#fibonacci-dropdown').all('option').collect(&:value)
    fibonacci_numbers = UserStory.estimation_series.map(&:to_s)

    expect(options[1..-1]).to eq(fibonacci_numbers[1..-1])
  end

  scenario 'should be able to edit a story' do
    within '#story-detail-modal' do
      find('.sentence .story-text').click
      fill_in 'user_story_description', with: 'This is the new user story'
      find('#save-user-story').click
    end

    wait_for_ajax
    user_story.reload
    expect(user_story.role).to eq(nil)
    expect(user_story.action).to eq(nil)
    expect(user_story.result).to eq(nil)

    expect(user_story.description).to eq('This is the new user story')
  end

  scenario 'should be able to see other actions' do
    find('.story-actions').click
    within '#story-detail-modal' do
      expect(page).to have_css('a.icn-delete')
      expect(page).to have_css('a.icn-archive', visible:false)
    end
  end

  scenario 'should change story points' do
    within '#story-detail-modal' do
      find("#groups-common-select-#{user_story.id}").find("option[value='#{group.id}']").select_option
    end

    wait_for_ajax
    user_story.reload
    expect(user_story.group).to eq(group)
  end
end
