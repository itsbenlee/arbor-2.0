module ArborReloaded
  class GoogleSheetsController < ApplicationController
    helper_method :service
    helper_method :project

    def authorization_callback
      redirect_to arbor_reloaded_project_user_stories_path(project,
        google_sheets_response: google_response)
    end

    private

    def project
      @project ||= Project.find(params[:state])
    end

    def service
      @service ||= Google::SheetsV4::ExportService.new(project,
        authorization_callback_arbor_reloaded_google_sheets_url)
    end

    def google_response
      service_response = service.export(params[:code])
      data = service_response.data

      if service_response.success
        spreadsheet_id = data[:spreadsheet_id]
        { success: true,
          url: "#{ENV['GOOGLE_SHEETS_BASE_URL']}/#{spreadsheet_id}" }
      else
        { success: false, errors: data[:errors] }
      end
    end
  end
end
