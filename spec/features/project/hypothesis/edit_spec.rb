require 'spec_helper'

feature 'Edit hypothesis' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }

  background do
    sign_in user
    visit project_hypotheses_path(project.id)
  end

  scenario 'edit form is diplayed when clicking on hypothesis title' do
    find('.hypothesis-show').click
    expect(page).to have_css '.hypothesis-title-field'
  end

  scenario 'edit hypothesis title' do
    updated_title =  'MY NEW HYPOTHESIS TITLE'

    find('.hypothesis-show').click

    within '.hypothesis-edit' do
      find('.hypothesis-title-field').set(updated_title)
    end

    within 'form.edit_hypothesis' do
      click_button :save
    end

    within '.hypothesis-show' do
      expect(find('.hypothesis-title')).to have_text updated_title
    end
  end

  scenario 'when editing user role the article should be correct', js: true do
    find('.hypothesis-show').click
    find('#user_story_role').native.send_keys('a','d','m','i','n')
    expect(find('.role-a-an').text).to eq('As an')

    visit project_hypotheses_path(project.id)
    
    find('.hypothesis-show').click
    find('#user_story_role').native.send_keys('u','s','e','r')
    expect(find('.role-a-an').text).to eq('As a')
  end
end
