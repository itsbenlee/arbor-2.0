require 'spec_helper'

feature 'Edit value proposition' do
  let(:user)             { create :user }
  let(:project)          { create :project, { owner: user, members: [user]} }
  let(:canvas)           { create :canvas, { project: project } }
  let(:hypothesis_title) { '.title-hypotheses-value-proposition' }

  background do
    sign_in user
  end

  scenario 'when change value proposition hypotheses title change' do
    visit project_canvas_path(project)
    find(".canvas-item[type='value-proposition']").click()
    updated_proposition = 'My new value proposition'
    fill_in :value_proposition, with: updated_proposition
    find('#save-canvas').click()
    visit project_hypotheses_path(project_id: project.id)
    expect(find(hypothesis_title)).to have_text(updated_proposition)
  end
end
