require 'spec_helper'

RSpec.describe ArborReloaded::TrelloController do
  let(:user)    { create :user }
  let(:project) { create :project }

  before :each do
    sign_in user
  end

  describe 'POST create' do
    it 'should export the project to trello' do
      VCR.use_cassette('trello/export') do
        post(
          :create,
          project_id: project.id,
          token: 'VALID_TRELLO_AUTH_TOKEN'
        )
        expect(response).to be_success
        result = JSON.parse(response.body)
        expect(result['data']['message']).to eq('Project exported to Trello succesfully')
        expect(result['errors']).to be_empty
      end
    end

    it 'should return an error message if the token es invalid' do
      VCR.use_cassette('trello/create_export') do
        post(
          :create,
          project_id: project.id,
          token: 'invalidToken'
        )
        expect(response).not_to be_success
        result = JSON.parse(response.body)
        expect(result['errors'])
          .to eq('There was an error exporting your project to Trello. Please try again later')
      end
    end
  end

  describe 'GET index' do
    render_views
    it 'should return the users boards on trello' do
      VCR.use_cassette('trello/get_boards') do
        get(
          :index,
          project_id: project.id,
          token: 'TRELLO_AUTH_TOKEN'
        )
        expect(response).to be_success
        expect(response.body).to have_select('board_id')
        expect(response.body).to have_content('MockProject')
        expect(response.body).to have_content('Tablero de bienvenida')
      end
    end
  end

  describe 'GET authorize' do
    render_views
    it 'should authorize Arbor on Trello' do
      expect(user.trello_token).to be_nil
      VCR.use_cassette('trello/authorize') do
        get(
          :authorize,
          token: 'TRELLO_AUTH_TOKEN',
          project_id: project.id
        )
        expect(response).to be_success
        user.reload
        expect(user.trello_token)
          .to eq('TRELLO_AUTH_TOKEN')
        expect(response.body).to have_link('trello_export_authorized')
        expect(response.body).to have_link('trello_export_board_authorized')
      end
    end
  end
end
