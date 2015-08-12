require 'spec_helper'

feature 'Add a project member' do
  before :each do
    @user = sign_in create :user
    @project = create :project, { owner: @user, members: [@user]}
  end

  scenario 'should show the project on sidebar' do
    visit root_url
    within 'aside' do
      expect(find('.project_link')).to  have_text @project.name
    end
  end

  scenario 'should not to show the project on sidebar' do
    project_not_member = create :project
    visit root_url
    within 'aside' do
      expect(find('.project_link')).not_to  have_text project_not_member.name
    end
  end
end
