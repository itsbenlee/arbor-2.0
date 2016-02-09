require 'spec_helper'

feature 'Display projects only for members' do
  background do
    @user = sign_in create :user
    @project = create :project, { owner: @user, members: [@user]}
  end

  scenario 'should show the project on sidebar' do
    visit projects_path

    within 'aside' do
      expect(page).to have_text @project.name
    end
  end

  scenario 'should not to show the project on sidebar' do
    project_not_member = create :project
    visit projects_path

    within 'aside' do
      expect(page).not_to have_text project_not_member.name
    end
  end
end
