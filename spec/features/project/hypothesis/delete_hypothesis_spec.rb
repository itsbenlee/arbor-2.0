require 'spec_helper'

feature 'Delete hypothesis' do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:hypothesis) { create :hypothesis, project: project }
  let(:epic)        { build :epic }

  background do
    sign_in user
    visit project_hypotheses_path project
  end

  scenario 'should show delete link' do
    expect(page).to have_link 'Delete Hypothesis'
  end

  scenario 'should delete the hypothesis after clicking the link' do
    click_link 'Delete Hypothesis'

    expect(Hypothesis.count).to eq 0
    expect(page).not_to have_content hypothesis.description
  end

  scenario 'should not delete associated epics' do
    epic.hypothesis = hypothesis
    epic.save

    visit project_hypotheses_path project

    %i(role action result).each do |field|
      expect(page).to have_content epic.send(field)
    end

    click_link 'Delete Hypothesis'

    expect(UserStory.count).to eq 1
    %i(role action result).each do |field|
      expect(page).not_to have_content epic.send(field)
    end
  end
end
