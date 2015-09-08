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
    expect(page).to have_css '.hypothesis-edit'
    expect(page).to have_css '.hypothesis-type-edit'
  end

  scenario 'edit form is diplayed when clicking on hypothesis type' do
    find('.hypothesis-type-show').click
    expect(page).to have_css '.hypothesis-edit'
    expect(page).to have_css '.hypothesis-type-edit'
  end

  scenario 'edit hypothesis title' do
    updated_title =  'MY NEW HYPOTHESIS TITLE'

    find('.hypothesis-type-show').click

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
end
