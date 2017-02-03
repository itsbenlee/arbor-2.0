require 'spec_helper'

feature 'Export backlog' do
  let!(:user)    { create :user }
  let!(:project) { create :project, owner: user }

  background do
    sign_in user
    visit arbor_reloaded_project_user_stories_path project
  end

  scenario 'should display export to pdf link' do
    expect(page).to have_css('.icn-export')
  end

  context 'when exporting project', js: true do
    background do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:create_event).and_return(true)

      click_link 'More...'
      click_link 'Download as PDF'
    end

    scenario 'should display export\'s as PDF modal' do
      expect(page).to have_selector('#export-as-pdf-modal', visible: true)
    end

    scenario 'should download a PDF', js: true do
      within '#export-as-pdf-modal' do
        click_button 'Download PDF'
        wait_for_ajax
      end

      response_headers = page.response_headers
      expect(response_headers['Content-Disposition']).to have_text(
        "#{project.name} Backlog.pdf"
      )
    end

    scenario 'should download a PDF with no estimation', js: true do
      within '#export-as-pdf-modal' do
        check 'estimation'
        click_button 'Download PDF'
        wait_for_ajax
      end

      response_headers = page.response_headers
      expect(response_headers['Content-Disposition']).to have_text(
        "#{project.name} Backlog.pdf"
      )
    end
  end
end
