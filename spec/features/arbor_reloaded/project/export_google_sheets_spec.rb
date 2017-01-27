require 'spec_helper'

feature 'Export backlog', js: true do
  let!(:user)          { create :user }
  let!(:project)       { create :project, owner: user }
  let(:redirect_uri)   { 'REDIRECT_URL' }
  let(:spreadsheet_id) { 'SPREADSHEET_ID'}
  let(:service)        { Google::SheetsV4::ExportService.new project, redirect_uri }
  let(:success)        { { success: true, data: { spreadsheet_id: spreadsheet_id } } }
  let(:failure)        { { success: false, errors: ['There was an error exporting your project to Google Sheets. Please try again later'] } }

  context 'when the user returns from the exportation' do
    background do
      sign_in user
      allow_any_instance_of(Google::SheetsV4::ExportService).to receive(:export).and_return([success, failure].sample)
      visit arbor_reloaded_project_user_stories_path project, google_sheets_response: service.export
    end

    scenario 'I should see the modal' do
      wait_for_ajax
      expect(page).to have_selector('#google-sheets-modal', visible: true)
    end

    scenario 'I should not see the button on the modal' do
      within '#google-sheets-modal' do
        expect(page).not_to have_selector('#google-sheets-export-submit')
      end
    end
  end

  context 'when the exportation is a success' do
    background do
      sign_in user
      allow_any_instance_of(Google::SheetsV4::ExportService).to receive(:export).and_return(success)
      visit arbor_reloaded_project_user_stories_path project, google_sheets_response: service.export
    end

    scenario 'I should see a success message' do
      within '#google-sheets-modal' do
        expect(page).to have_text('Project exported to Google Sheets successfully!')
      end
    end

    scenario 'I should not see an error message' do
      within '#google-sheets-modal' do
        expect(page).not_to have_text('There was an error exporting your project to Google Sheets. Please try again later')
      end
    end
  end

  context 'when the exportation is a failure' do
    background do
      sign_in user
      allow_any_instance_of(Google::SheetsV4::ExportService).to receive(:export).and_return(failure)
      visit arbor_reloaded_project_user_stories_path project, google_sheets_response: service.export
    end

    scenario 'I should not see a success message' do
      within '#google-sheets-modal' do
        expect(page).not_to have_text('Project exported to Google Sheets successfully!')
      end
    end

    scenario 'I should see an error message' do
      within '#google-sheets-modal' do
        expect(page).to have_text('There was an error exporting your project to Google Sheets. Please try again later')
      end
    end
  end
end
