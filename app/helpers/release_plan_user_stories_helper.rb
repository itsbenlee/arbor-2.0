module ReleasePlanUserStoriesHelper
  # rubocop:disable Style/StringLiterals
  def format_user_story_text(user_story)
    description = user_story[:description]
    return description if description

    """#{t('reloaded.backlog.role')} #{user_story[:role]}
    #{t('reloaded.backlog.action')} #{user_story[:action]}
    #{t('reloaded.backlog.result')} #{user_story[:result]}"""
  end

  def current_sprint(delivery_date)
    return unless Time.zone.today.between?(
      delivery_date - 6.days, delivery_date
    )

    'current-sprint'
  end
end
