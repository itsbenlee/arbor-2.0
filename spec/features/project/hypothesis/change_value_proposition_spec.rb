require 'spec_helper'

feature 'Show the actual canvas value proposition on hypotheses' do
  let!(:user)            { create :user }
  let!(:project)         { create :project, { owner: user, members: [user]} }
  let!(:canvas)          { create :canvas, { project: project } }
  let(:hypothesis_title) { '.title-value-proposition' }
  let(:hypothesis_form)  { '.hypotheses-value-proposition' }

  background do
    sign_in user
  end

  scenario 'when the value proposition not change' do
    visit project_hypotheses_path(project_id: project.id)
    expect(find(hypothesis_title)).to have_text(canvas.value_proposition)
  end

  scenario 'when click hypotheses title the edit value proposition form is shown' do
    visit project_hypotheses_path(project_id: project.id)
    find(hypothesis_title).click
    expect(page).to have_css(hypothesis_form)
  end

  scenario 'update hypotheses title works' do
    visit project_hypotheses_path(project_id: project.id)
    find(hypothesis_title).click
    updated_proposition = 'A new value proposition'

    within hypothesis_form do
      fill_in :value_proposition, with: updated_proposition
      click_button :save
    end

    expect(find(hypothesis_title)).to have_text(updated_proposition)
  end
end
