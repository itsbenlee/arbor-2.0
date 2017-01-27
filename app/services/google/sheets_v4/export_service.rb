require 'googleauth'
require 'google_drive'
require 'google/apis/sheets_v4'

module Google
  module SheetsV4
    class ExportService
      ROW_TITLE = 1
      SHEET_ID = 0

      def initialize(project, redirect_uri)
        @project = project
        @redirect_uri = redirect_uri
        @common_response = CommonResponse.new(true, [])
      end

      def google_sheets_authentication_url
        credentials.authorization_uri.to_s
      end

      def export(code)
        @current_row = ROW_TITLE
        @group_points_rows = []
        @spreadsheet = session(code).create_spreadsheet @project.name
        @ws = @spreadsheet.worksheets[SHEET_ID]

        write_title_and_description
        write_header
        write_ungrouped_user_stories if @project.user_stories.ungrouped.any?
        write_groups_with_stories
        write_results_table

        format_worksheet

        @ws.synchronize
        @common_response.data[:spreadsheet_id] = @spreadsheet.key
        @common_response
      rescue => error
        process_error(error)
        @common_response
      end

      private

      def step(step = 1)
        @current_row += step
      end

      def credentials
        @credentials ||= Google::Auth::UserRefreshCredentials.new(
          client_id: ENV['GOOGLE_SHEETS_CLIENT_ID'],
          client_secret: ENV['GOOGLE_SHEETS_CLIENT_SECRET'],
          scope: [
            'https://www.googleapis.com/auth/drive',
            'https://spreadsheets.google.com/feeds/'
          ],
          state: @project.id,
          redirect_uri: @redirect_uri
        )
      end

      def process_error(_error)
        @common_response.success = false
        @common_response.errors << I18n.t('google_sheets.modal.error')
      end

      def session(code)
        credentials.code = code
        credentials.fetch_access_token!
        GoogleDrive::Session.from_credentials(credentials)
      end

      def write_title_and_description
        @ws[@current_row, 3] = I18n.t('google_sheets.worksheet.title')
        step 2

        I18n.t('google_sheets.worksheet.description').each do |item|
          @ws[@current_row, 3] = item
          step
        end
        step
      end

      def write_header
        @header_row = @current_row
        @story_row = @current_row + 4
        @ws[@header_row, 1] = I18n.t('google_sheets.worksheet.header')
        @ws[@header_row + 2, 2] = I18n.t('google_sheets.worksheet.complexity')

        @project.total_weeks.times.each do |sprint|
          @ws[@header_row, sprint + 3] =
            "#{I18n.t('google_sheets.worksheet.sprint_header')} #{sprint}"
          next if sprint == 0

          column_chr = (sprint + 67).chr
          @ws[@header_row + 2, sprint + 3] =
            "=SUMIF(#{column_chr}#{@story_row}:#{column_chr}"\
            "#{@ws.max_rows}; \"-\"; "\
            "B#{@story_row}:#{column_chr}#{@ws.max_rows})"
        end
      end

      def write_ungrouped_user_stories
        @current_row = @story_row
        count = @current_row + @project.user_stories.ungrouped.count

        @ws[@current_row, 1] = I18n.t('google_sheets.worksheet.ungrouped')
        @ws[@current_row, 2] = "=SUM(B#{@current_row + 1}:B#{count})"
        @group_points_rows << @current_row

        write_user_stories @project.user_stories.ungrouped
      end

      def write_groups_with_stories
        @project.groups.each do |group|
          count = group.user_stories.any? ? group.user_stories.count : 1
          count += @current_row

          @ws[@current_row, 1] = group.name
          @ws[@current_row, 2] = "=SUM(B#{@current_row + 1}:B#{count})"
          @group_points_rows << @current_row

          write_user_stories group.user_stories
        end
      end

      def write_user_stories(user_stories)
        step
        user_stories.each do |user_story|
          @ws[@current_row, 1] = user_story.log_description
          @ws[@current_row, 2] = user_story.estimated_points
          step
        end
        step
      end

      def write_results_table
        @last_row = @current_row

        col = @project.total_weeks + 4
        @current_row = @story_row

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.delivered')
        @ws[@current_row, col + 1] = '√'
        step

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.in_progress')
        @ws[@current_row, col + 1] = '-'
        step

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.planned')
        @ws[@current_row, col + 1] = '-'
        step

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.advanced')
        @ws[@current_row, col + 1] = '-'
        step

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.points')
        @ws[@current_row, col + 1] =
          "=SUM(#{@group_points_rows.map { |points| "B#{points}" }.join(';')})"
        step

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.sprints')
        @ws[@current_row, col + 1] = @project.total_weeks + 1
        step 4

        @ws[@current_row, col] = I18n.t('google_sheets.worksheet.ppw')
        @ws[@current_row, col + 1] = "=#{(col + 65).chr}#{@current_row - 5}/" \
                                     "#{(col + 65).chr}#{@current_row - 4}"
      end

      def format_worksheet
        formatter = Google::SheetsV4::Formatter.new
        requests = []

        requests << formatter.title
        requests << formatter.description
        requests << formatter.header(@header_row - 1, @header_row + 2,
                                     0, @project.total_weeks + 3)
        requests << formatter.estimation_column(@story_row - 2, @last_row - 1)

        @group_points_rows.each { |row| requests << formatter.group_name(row) }

        requests << formatter.delivered_cell(@story_row - 1,
                                             @story_row,
                                             @project.total_weeks + 4,
                                             @project.total_weeks + 5)
        requests << formatter.in_progress_cell(@story_row,
                                               @story_row + 1,
                                               @project.total_weeks + 4,
                                               @project.total_weeks + 5)
        requests << formatter.planned_cell(@story_row + 1,
                                           @story_row + 2,
                                           @project.total_weeks + 4,
                                           @project.total_weeks + 5)
        requests << formatter.advanced_cell(@story_row + 2,
                                  @story_row + 3,
                                  @project.total_weeks + 4,
                                  @project.total_weeks + 5)

        service = Google::Apis::SheetsV4::SheetsService.new
        service.authorization = credentials
        service.batch_update_spreadsheet(@spreadsheet.key,
                                         { requests: requests },
                                         {})
      rescue => error
        process_error(error)
        @common_response
      end
    end
  end
end
