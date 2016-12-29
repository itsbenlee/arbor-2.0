module ArborReloaded
  class GoogleSheetsController < ApplicationController

    def authorization_callback
      project = Project.find(params[:state])
      response = ArborReloaded::GoogleSheetsServices.new(project, authorization_callback_arbor_reloaded_google_sheets_url).export(params[:code])

      if response.success
        redirect_to arbor_reloaded_project_user_stories_path(project, google_sheets_export: { success: true, url: "https://docs.google.com/spreadsheets/d/#{response.data[:spreadsheet_id]}" })
      else
        redirect_to arbor_reloaded_project_user_stories_path(project, google_sheets_export: { success: false, errors: response.data[:errors] })
      end
    end
  end
end
