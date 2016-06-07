require 'spec_helper'
module ArborReloaded
  feature 'Export Trello Services' do
    let(:user)           { create :user }
    let(:project)        { create :project }
    let(:token)          { 'TRELLO_TOKEN' }
    let(:trello_service) { ArborReloaded::TrelloServices.new(project, token) }
    let(:board_id)       { 'VALID_BOARD_ID' }
    let(:error_message)  { 'There was an error exporting your project to Trello. Please try again later' }

    context 'export with a valid token' do
      scenario 'should return success' do
        VCR.use_cassette('trello/service_export') do
          response = trello_service.export
          expect(response.success).to be true
        end
      end
    end

    context 'export with an invalid token' do
      let(:service) { ArborReloaded::TrelloServices.new(project, 'INVALID') }

      scenario 'should not throw an error and return an error message' do
        VCR.use_cassette('trello/service_export') do
          expect { service.export }.to_not raise_exception
          response = service.export
          expect(response.errors).to eq(error_message)
          expect(response.success).to be false
        end
      end
    end

    context 'list boards with a valid token' do
      scenario 'should return success' do
        VCR.use_cassette('trello/service_list_boards') do
          response = trello_service.list_boards
          expect(response.success).to be true
        end
      end
    end

    context 'list boards with an invalid token' do
      let(:service) { ArborReloaded::TrelloServices.new(project, 'INVALID') }

      scenario 'should not throw an error and return an error message' do
        VCR.use_cassette('trello/service_list_boards') do
          expect { service.list_boards }.to_not raise_exception
          response = service.list_boards
          expect(response.errors).to eq(error_message)
          expect(response.success).to be false
        end
      end
    end

    context 'export to existing board with valid token and board_id' do
      scenario 'should return success' do
        VCR.use_cassette('trello/service_export_to_board') do
          response = trello_service.export_to_existing_board(board_id)
          expect(response.success).to be true
        end
      end
    end

    context 'export to existing board with invalid token' do
      let(:service) { ArborReloaded::TrelloServices.new(project, 'INVALID') }

      scenario 'should not throw an error and return an error message' do
        VCR.use_cassette('trello/service_export_to_board') do
          expect { service.export_to_existing_board(board_id) }.to_not raise_exception
          response = service.export_to_existing_board(board_id)
          expect(response.errors).to eq(error_message)
          expect(response.success).to be false
        end
      end
    end

    context 'export to existing board with invalid board_id' do
      let(:invalid_id) { 'INVALID' }

      scenario 'should not throw an error and return success false' do
        VCR.use_cassette('trello/service_export_to_board') do
          expect { trello_service.export_to_existing_board(invalid_id) }.to_not raise_exception
          response = trello_service.export_to_existing_board(invalid_id)
          expect(response.success).to be false
        end
      end
    end
  end
end
