module ReleasePlanUserStoriesHelper
  # rubocop:disable Style/StringLiterals
  def format_user_story_text(user_story)
    description = user_story[:description]
    return description if description

    """#{t('reloaded.backlog.role')} #{user_story[:role]}
    #{t('reloaded.backlog.action')} #{user_story[:action]}
    #{t('reloaded.backlog.result')} #{user_story[:result]}"""
  end

  def sprint_user_story_current_status(sprint_id, user_story_id)
    sprint_user_story = SprintUserStory.find_by(
      sprint_id: sprint_id,
      user_story_id: user_story_id
    )

    return '' unless sprint_user_story
    sprint_user_story.status
  end

  def sprint_user_story_next_status(current_status)
    case current_status
    when 'PLANNED' then 'WIP'
    when 'WIP' then 'DONE'
    when 'DONE' then ''
    else
      'PLANNED'
    end
  end
end
