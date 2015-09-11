require 'trello'
class TrelloServices
  def initialize(project, token)
    @project = project
    @token = token
    config
  end

  def export
    fields = {
      name: @project.name,
      closed: false,
      starred: false
    }

    board = Trello::Board.create(fields)
    board.lists.each(&:close!)
    list = Trello::List.create(
      name: I18n.t('trello.default_list'), board_id: board.id)

    @project.user_stories.each do |user_story|
      Trello::Card.create(name: user_story.log_description, list_id: list.id)
    end
  end

  private

  def config
    Trello.configure do |config|
      config.member_token = @token
      config.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
    end
  end
end
