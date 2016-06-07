module ApplicationHelper
  def meta_title
    ENV['META_TITLE'] || 'Arbor'
  end

  def meta_description
    ENV['META_DESCRIPTION'] || 'Add meta description'
  end

  def user_initial(user)
    user.email[0].upcase
  end
end
