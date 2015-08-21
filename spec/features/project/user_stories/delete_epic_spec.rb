require 'spec_helper'

feature 'Delete epic' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let!(:epic)       { create :epic, project: project, hypothesis: hypothesis }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show delete link' do
    expect(page).to have_link 'Delete Epic'
  end

  scenario 'should delete the epic after clicking the link' do
    click_link 'Delete Epic'

    expect(UserStory.count).to eq 0
    %i(role action result).each do |field|
      expect(page).not_to have_content epic.send(field)
    end
  end
end
