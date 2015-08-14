require 'spec_helper'

feature 'Show project details' do
  let!(:user)      { create :user }
  let!(:user_project_a)   { create :project, members: [user] }
  let!(:user_project_b)   { create :project, members: [user] }
  let!(:non_user_project) { create :project }

  before :each do
    sign_in user
    visit projects_path
  end

  scenario 'should show all associated project ids' do
    expect(page).to have_content user_project_a.id
    expect(page).to have_content user_project_b.id
    expect(page).not_to have_content non_user_project.id
  end

  scenario 'should show all associated project names' do
    expect(page).to have_content user_project_a.name
    expect(page).to have_content user_project_b.name
    expect(page).not_to have_content non_user_project.name
  end

  scenario 'should show a link for all associated projects details' do
    expect(page).to have_href project_path(user_project_a)
    expect(page).to have_href project_path(user_project_b)
    expect(page).not_to have_href project_path(non_user_project)
  end

  scenario 'should show an edit link for all associated projects' do
    expect(page).to have_href edit_project_path(user_project_a)
    expect(page).to have_href edit_project_path(user_project_b)
    expect(page).not_to have_href edit_project_path(non_user_project)
  end
end
