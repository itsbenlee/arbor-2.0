module ArborReloaded
  class TrelloController < ApplicationController
    before_action :load_project, except: :new
    before_action :load_token, except: :new
    layout 'application_reload'

    def index
      response = ArborReloaded::TrelloServices.new(@project, @token).list_boards
      render partial: 'arbor_reloaded/trello/select_board',
             locals: { response: response, project: @project, token: @token }
    end

    def new
    end

    def create
      response = ArborReloaded::TrelloServices.new(@project, @token).export
      positive_response = response.success
      if positive_response
        response.data[:message] = t('trello.success')
        ArborReloaded::IntercomServices.new(current_user).export_to_trello_event
      end
      render json: response, status: (positive_response ? 201 : 422)
    end

    def export_to_board
      board_id = params.require(:board_id)
      @response = ArborReloaded::TrelloServices.new(@project, @token)
                  .export_to_existing_board(board_id)
      return unless @response.success
      @response.data[:message] = t('trello.success')
      ArborReloaded::IntercomServices.new(current_user).export_to_trello_event
    end

    private

    def load_token
      @token = params.require(:token)
      return unless current_user.trello_token != @token
      current_user.update_attributes(trello_token: @token)
    end

    def load_project
      id = params[:id] || params[:project_id]
      @project = Project.find(id)
    end
  end
end
