require 'spec_helper'

feature 'Canvas question change for each canvas step' do
  let!(:member)  { create :user }
  let!(:project) { create :project, members: [member] }
  let!(:canvas)  { create :canvas, project: project }

  background do
    sign_in member
    visit arbor_reloaded_project_canvases_path(project)
  end

  scenario 'should stay on the answered question' do
    find('.solutions-field textarea').set('My solution proposal')
    find('#save-canvas', visible: false).click
    within '.right-content-wrapper' do
      expect(page).to have_text(I18n.t('solutions_title'))
      expect(page).to have_text('My solution proposal')
    end
  end

  scenario 'for problem step' do
    find(".canvas-item[type='problems']").click()
    question = 'What are the top three problems that you are trying to solve?'
    expect(find('.problems-field label')).to have_content(question)
  end

  scenario 'for solutions step' do
    find(".canvas-item[type='solutions']").click()
    question = 'What are the top three features that solve your identified pain points or problems?'
    expect(find('.solutions-field label')).to have_content(question)
  end

  scenario 'for alternative step' do
    find(".canvas-item[type='alternative']").click()
    question = 'How are users solving or overcoming these problems today, if at all?'
    expect(find('.alternative-field label')).to have_content(question)
  end

  scenario 'for advantage step' do
    find(".canvas-item[type='advantage']").click()
    question = 'What about your solution can\'t be easily copied or bought.'
    expect(find('.advantage-field label')).to have_content(question)
  end

  scenario 'for segment step' do
    find(".canvas-item[type='segment']").click()
    question = 'Who are your target customers?'
    expect(find('.segment-field label')).to have_content(question)
  end

  scenario 'for channel step' do
    find(".canvas-item[type='channel']").click()
    question = 'What are your main path(s) to customers?'
    expect(find('.channel-field label')).to have_content(question)
  end

  scenario 'for value proposition step' do
    find(".canvas-item[type='value-proposition']").click()
    question = 'Write a single, clear compelling message that states why you are different and worth taking notice of.'
    expect(find('.value-proposition-field label')).to have_content(question)
  end

  scenario 'for revenue streams step' do
    find(".canvas-item[type='revenue-streams']").click()
    question = 'What is your revenue model, gross margin, and proposed path to revenue?'
    expect(find('.revenue-streams-field label')).to have_content(question)
  end

  scenario 'for cost structure step' do
    find(".canvas-item[type='cost-structure']").click()
    question = 'What are your customer acquisition costs, distribution costs, people, hosting, integration partners, etc?'
    expect(find('.cost-structure-field label')).to have_content(question)
  end
end