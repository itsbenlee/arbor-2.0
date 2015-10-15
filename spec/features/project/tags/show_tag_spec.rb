require 'spec_helper'

feature 'Show tag', js: true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }
  let!(:tag)        { create :tag, name: 'MyTag', project: project }

  background do
    sign_in user
    visit project_user_stories_path project
    find('.user-story').click
    find('span.show-role').click
    check('MyTag')
  end

  scenario 'should view tags on the overview section' do
    within('.user-stories-list-container') do
      expect(page).to have_content('MYTAG')
    end
  end
end
