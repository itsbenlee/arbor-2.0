require 'spec_helper'

feature 'Estimation totals', js:true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user, velocity: 5, cost_per_week: 10 }
  let!(:user_story) { create :user_story, project: project, estimated_points: 8 }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
  end

  scenario 'live updates when estimating a story' do
    allow_any_instance_of(ArborReloaded::IntercomServices)
      .to receive(:create_event).and_return(true)

    find('.story-detail-link').click
    find('#fibonacci-dropdown').find('option[value="21"]').select_option
    wait_for_ajax

    expect(page).to have_content('21')
    expect(page).to have_content('$50')
    expect(page).to have_content('5')
  end

  context 'when total points are lower than velocity' do
    background do
      project.update_attributes(velocity: 13)
      visit current_path
    end

    scenario 'should round to 1' do
      expect(find('.total_points')).to have_content('8')
      expect(find('.total_cost')).to have_content('$10')
      expect(find('.total_weeks')).to have_content('1')
    end
  end

  context 'when the division is not exact' do
    background do
      project.update_attributes(velocity: 5)
      visit current_path
    end

    scenario 'should round to 2' do
      expect(find('.total_points')).to have_content('8')
      expect(find('.total_cost')).to have_content('$20')
      expect(find('.total_weeks')).to have_content('2')
    end
  end

  scenario 'I sould access to estimation settings from extimation boxes' do
    within '.total-points' do
      find('.icn-settings', visible: false).trigger('click')
    end

    expect(page).to have_content('Estimation Settings')
  end
end
