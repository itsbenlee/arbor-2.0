require 'spec_helper'

feature 'Change complete percentage' do
  before :each do
    @member = create :user
    @project = create :project, { members: [@member] }
  end

  scenario 'should be 80% for a canvas with 0 number of answered questions' do
    create :canvas, :uncomplete, { project: @project }
    sign_in @member
    visit project_canvas_path(@project)
    expect(find('.percentage span')).to have_text('0%')
  end

  scenario 'should be 88% for a canvas with 8 number of answered questions' do
    create :canvas, :without_problems, { project: @project }
    sign_in @member
    visit project_canvas_path(@project)
    expect(find('.percentage span')).to have_text('88%')
  end

  scenario 'should show 100% percentage for a new canvas' do
    create :canvas, { project: @project }
    sign_in @member
    visit project_canvas_path(@project)
    expect(find('.percentage span')).to have_text('100%')
  end

  scenario 'should be 11% for a canvas with 1 number of answered questions' do
    sign_in @member
    visit project_canvas_path(@project)
    find('.problems-field textarea').set('My problem proposal')
    click_button 'save-canvas'
    expect(find('.percentage span')).to have_text('11%')
  end
end
