require 'spec_helper'

feature 'Story list' do
  include ActionView::Helpers::NumberHelper
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_stories) { create_list :user_story, 2, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  def separate_comma(number)
    new = number_with_delimiter(number, delimiter: ',')
  end

  scenario 'should list all stories' do
    user_stories.each do |story|
      within '.user-stories-container' do
        expect(find("#story-text-#{story.id}").text)
        .to have_content("As a #{story.role} I want #{story.action} so that #{story.result}")
      end
    end
  end

  scenario 'should be able to find the bulk action menu', js: true do
    expect(page).not_to have_css('.sticky-menu')

    first("input[type='checkbox']").trigger('click')
    expect(page).to have_css('.sticky-menu')
  end

  scenario 'should be able to find estimation widget' do
    expect(page).to have_css('.estimation-wrapper')
  end

  scenario 'should let me introduce the velocity and', js: true do
    total_points = UserStory.total_points(project.user_stories)

    find('a.icn-settings').trigger('click')
    fill_in 'project_velocity', with: '1'
    fill_in 'project_cost_per_week', with: '500'
    find('#submit-edit-project-form').trigger('click')

    within('.total_points') do
      expect(page).to have_content(total_points)
    end

    within('.total_cost') do
      total_cost = (total_points * 500)
      expect(page).to have_content(number_with_delimiter(total_cost, delimiter: ','))
    end

    within('.total_weeks') do
      expect(page).to have_content(total_points)
    end
  end
end
