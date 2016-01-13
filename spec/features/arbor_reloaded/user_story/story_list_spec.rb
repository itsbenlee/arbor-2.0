require 'spec_helper'

feature 'Story list' do
  let!(:user)         { create :user }
  let!(:project)      { create :project, owner: user }
  let!(:user_stories) { create_list :user_story, 2, project: project }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path(project)
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
end
