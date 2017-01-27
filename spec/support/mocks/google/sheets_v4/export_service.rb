module Google
  module SheetsV4
    class ExportService
      def initialize(_project, _redirect_uri)
        @common_response = CommonResponse.new(true, [])
      end

      def google_sheets_authentication_url
        'AUTHENTICATION_URL'
      end

      def export(code)
        if code == 'VALID_CODE'
          @common_response.data[:spreadsheet_id] = 'SPREADSHEET_ID'
        else
          process_error(nil)
        end

        @common_response
      end

      private

      def process_error(_error)
        @common_response.success = false
        @common_response.errors << 'There was an error exporting your project' \
                                   ' to Google Sheets. Please try again later'
      end
    end
  end
end
