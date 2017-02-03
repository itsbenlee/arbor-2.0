require 'spec_helper'

describe Google::SheetsV4::ExportService do
  class DummyWorksheet
    def synchronize; @arr = @tmp_arr end
    def inspect; @arr.inspect end
    def max_rows; 100 end

    def []=(row, column, value)
      @tmp_arr ||= []
      @tmp_arr[row] ||= []
      @tmp_arr[row][column] = value
    end

    def include?(value)
      @arr.any? { |row| row && row.include?(value) } if @arr
    end
  end

  feature '#export' do
    let(:project_velocity) { 10 }
    let(:project)          { create(:project, velocity: project_velocity) }
    let!(:user_stories)    { create_list(:user_story, 3, project: project,
                                                         estimated_points: 2) }
    let(:redirect_uri)  { 'http://localhost/test' }
    let(:service)       { Google::SheetsV4::ExportService.new(project,
      redirect_uri) }

    context 'when the user provides the correct credentials' do
      let(:spreadsheet_id) { 'spreadsheet_id' }
      let(:worksheet)      { DummyWorksheet.new }
      let(:worksheets)     { [worksheet] }
      let(:spreadsheet)    { double(:spreadsheet, key: spreadsheet_id,
                                                  worksheets: worksheets) }
      let(:session)        { double(:session, create_spreadsheet: spreadsheet) }

      before do
        allow(service).to receive(:session) { session }
        allow(service).to receive(:update_spreadsheet) { }
        allow(service).to receive(:synchronize) { }
      end

      scenario 'exports successfully' do
        expect(service.export(nil).success).to be true
      end

      scenario 'returns the spreadsheet id' do
        expect(service.export(nil)
          .data[:spreadsheet_id]).to eq(spreadsheet_id)
      end

      scenario 'includes Release Overview' do
        service.export(nil)

        expect(worksheet).to include('V1 Release Overview')
        expect(worksheet).to include('Sprint 0')
      end


      context 'having a couple of user stories' do
        let(:user_story1) { create(:user_story, project: project,
                                                role: 'user',
                                                action: 'to have a mug',
                                                result: 'I can drink coffee') }
        let(:user_story2) { create(:user_story, project: project,
                                                role: 'mug',
                                                action: 'to have coffee',
                                                result: 'the user can drink it') }
        let!(:user_stories) { [user_story1, user_story2] }

        scenario 'include user stories' do
          service.export(nil)

          expect(worksheet).to include(
            'As a user I want to have a mug so that I can drink coffee'
          )
          expect(worksheet).to include(
            'As a mug I want to have coffee so that the user can drink it'
          )
        end
      end

      context 'when less points than velocity' do
        let(:project_velocity) { 20 }

        scenario 'creates only one sprint' do
          service.export(nil)

          expect(worksheet).to include('Sprint 0')
          expect(worksheet).to include('Sprint 1')
          expect(worksheet).to_not include('Sprint 2')
        end
      end

      context 'when more points than velocity' do
        let(:project_velocity) { 2 }

        scenario 'creates multiple sprints' do
          service.export(nil)

          expect(worksheet).to include('Sprint 0')
          expect(worksheet).to include('Sprint 1')
          expect(worksheet).to include('Sprint 2')
          expect(worksheet).to include('Sprint 3')
          expect(worksheet).to_not include('Sprint 4')
        end
      end
    end

    context 'when the user provides wrong credentials' do
      scenario do
        VCR.use_cassette('google/invalid_credentials') do
          expect(service.export('invalid code').success).to be false
        end
      end

      scenario do
        VCR.use_cassette('google/invalid_credentials') do
          expect(service.export('invalid code').errors).to eq(
            ['There was an error exporting your project to Google Sheets. Please try again later'])
        end
      end
    end
  end
end
