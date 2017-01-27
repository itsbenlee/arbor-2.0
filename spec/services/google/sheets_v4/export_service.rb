require 'spec_helper'

module Google
  module SheetsV4
    feature '#export' do
      let(:project)      { create :project }
      let(:redirect_uri) { 'REDIRECT_URI' }
      let(:valid_code)   { 'VALID_CODE' }
      let(:invalid_code) { 'INVALID_CODE'}
      let(:service)      { Google::SheetsV4::ExportService.new(project,
        redirect_uri) }

      context 'when the user provides the correct credentials' do
        scenario { expect(service.export(valid_code).success).to be true }
        scenario { expect(service.export(valid_code).data[:spreadsheet_id]).to eq('SPREADSHEET_ID') }
      end

      context 'when the user provides wrong credentials' do
        scenario { expect(service.export(invalid_code).success).to be false }

        scenario do
          expect(service.export(invalid_code).errors).to eq(
            ['There was an error exporting your project to Google Sheets. Please try again later'])
        end
      end
    end
  end
end
