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

    @board = Trello::Board.create(fields)
    @board.lists.each(&:close!)
    new_list = Trello::List.create(
      name: I18n.t('trello.default_list'), board_id: @board.id)

    export_stories(new_list)
  end

  private

  def export_stories(list)
    @project.user_stories.each do |user_story|
      new_card_name =
        "[#{user_story.story_number}] "\
        "(#{user_story.estimated_points}) #{user_story.log_description}"
      new_card = Trello::Card.create(name: new_card_name, list_id: list.id)

      create_acceptance_criterions_checklist(user_story, new_card)
      create_constraints_checklist(user_story, new_card)
    end
  end

  %w(acceptance_criterions constraints).each do |type|
    define_method("create_#{type}_checklist") do |user_story, new_card|
      checklist = Trello::Checklist.create(
        name: I18n.t("backlog.#{type}"),
        board_id: @board.id,
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
  end
end
