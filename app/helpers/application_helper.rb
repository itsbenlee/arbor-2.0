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

  def google_sheets_authentication_url(project)
    arbor_reloaded_project_export_to_google_path(project.id)
  end
end
