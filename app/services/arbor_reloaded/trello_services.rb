require 'trello'
module ArborReloaded
  class TrelloServices
    def initialize(project, token)
      @project = project
      @token = token
      config
      @common_response = CommonResponse.new(true, [])
    end

    def export
      fields = {
        name: @project.name,
        closed: false,
        starred: false
      }
      create_list(Trello::Board.create(fields))
      @common_response
    rescue => error
      process_error(error)
      @common_response
    end

    def list_boards
      @common_response.data[:boards] =
      Trello::Board.all.select { |board| board.closed == false }
      @common_response
    rescue => error
      process_error(error)
      @common_response
    end

    def export_to_existing_board(board_id)
      new_list = Trello::List.create(
        name: I18n.t('trello.default_list'), board_id: board_id)
      export_stories(new_list)
      @common_response
    rescue => error
      process_error(error)
      @common_response
    end

    private

    def process_error(error)
      if error.message == 'invalid token'
        @common_response.data[:token_error] = true
      end
      @common_response.success = false
      @common_response.errors = I18n.t('trello.error')
    end

    def create_list(board)
      board.lists.each(&:close!)
      new_list = Trello::List.create(
        name: I18n.t('trello.default_list'), board_id: board.id)
      export_stories(new_list)
    rescue => error
      process_error(error)
      @common_response
    end

    def export_stories(list)
      @project.user_stories.each do |user_story|
        new_card_name =
          "[#{user_story.story_number}] "\
          "(#{user_story.points_for_trello}) #{user_story.log_description}"
        new_card = Trello::Card.create(name: new_card_name, list_id: list.id)

        create_acceptance_criterions_checklist(user_story, new_card)
        create_constraints_checklist(user_story, new_card)
      end
    end

    %w(acceptance_criterions constraints).each do |type|
      define_method("create_#{type}_checklist") do |user_story, new_card|
        checklist = Trello::Checklist.create(
          name: I18n.t("backlog.#{type}"),
          board_id: new_card.board.id,
          card_id: new_card.id)

        user_story.send(type.to_sym).each do |element|
          checklist.add_item(element.description)
        end
      end
    end

    def config
      Trello.configure do |config|
        config.member_token = @token
        config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
      end
    rescue
      @common_response.success = false
      @common_response.errors = I18n.t('trello.error')
      @common_response
    end
  end
end
