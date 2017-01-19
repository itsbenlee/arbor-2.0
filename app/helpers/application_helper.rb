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
    callback = authorization_callback_arbor_reloaded_google_sheets_url
    service = Google::SheetsV4::ExportService.new(project, callback)
    service.google_sheets_authentication_url
  end
end
