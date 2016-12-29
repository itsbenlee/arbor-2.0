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
    ArborReloaded::GoogleSheetsServices.new(project, authorization_callback_arbor_reloaded_google_sheets_url).google_sheets_authentication_url
  end
end
