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

      def export(code)
        @current_row = ROW_TITLE
        @group_points = []
        @spreadsheet = session(code).create_spreadsheet(@project.name)
        @ws = @spreadsheet.worksheets[SHEET_ID]

        load_spreadsheet

        @ws.synchronize

        process_success
      rescue Signet::AuthorizationError => error
        process_error(error)
      end

      def google_sheets_authentication_url
        credentials.authorization_uri.to_s
      end

      private

      def process_success
        @common_response.data[:spreadsheet_id] = @spreadsheet.key
        @common_response
      end

      def process_error(_error)
        @common_response.success = false
        @common_response.errors << Translations::MODAL_ERROR
        @common_response
      end

      def advance_current_row(step = 1)
        @current_row += step
      end

      def set_cell_value(row, column, value)
        @ws[row, column] = value
      end

      def set_column_value(column, value)
        set_cell_value(@current_row, column, value)
      end

      def load_spreadsheet
        load_title_and_description
        load_header
        load_ungrouped
        load_groups
        load_results
        load_format
      end

      def load_title_and_description
        set_column_value 3, Translations::WORKSHEET_TITLE
        advance_current_row 2

        Translations::WORKSHEET_DESCRIPTION.each do |item|
          set_column_value 3, item
          advance_current_row
        end
        advance_current_row
      end

      def load_header
        @header_row = @current_row
        @story_row = @current_row + 4

        set_cell_value @header_row, 1, Translations::WORKSHEET_HEADER
        set_cell_value @header_row + 2, 2, Translations::WORKSHEET_COMPLEXITY

        load_header_sprint
      end

      def load_header_sprint
        set_cell_value @header_row, 3,
          "#{Translations::WORKSHEET_SPRINT_HEADER} 0"

        (1..@project.total_weeks).each do |sprint|
          set_cell_value @header_row, sprint + 3,
            "#{Translations::WORKSHEET_SPRINT_HEADER} #{sprint}"
          set_cell_value @header_row + 2, sprint + 3,
            Calculations::Sum.row((sprint + 67).chr, @story_row, @ws.max_rows)
        end
      end

      def load_ungrouped
        stories = @project.user_stories.ungrouped
        return unless stories.any?

        @current_row = @story_row
        count = @current_row + stories.count

        set_column_value 1, Translations::WORKSHEET_UNGROUPED
        set_column_value 2, Calculations::Sum.stories(@current_row, count)
        @group_points << @current_row

        load_user_stories stories
      end

      def load_groups
        @project.groups.each do |group|
          stories = group.user_stories
          count = (stories.any? ? stories.count : 1) + @current_row

          set_column_value 1, group.name
          set_column_value 2, Calculations::Sum.stories(@current_row, count)
          @group_points << @current_row

          load_user_stories stories
        end
      end

      def load_user_stories(user_stories)
        advance_current_row
        user_stories.each do |user_story|
          set_column_value 1, user_story.log_description
          set_column_value 2, user_story.estimated_points
          advance_current_row
        end
        advance_current_row
      end

      def load_results
        @last_row = @current_row
        @current_row = @story_row

        load_results_row Translations::WORKSHEET_DELIVERED, '√'
        load_results_row Translations::WORKSHEET_IN_PROGRESS, '-'
        load_results_row Translations::WORKSHEET_PLANNED, '-'
        load_results_row Translations::WORKSHEET_ADVANCED, '-'
        load_results_row Translations::WORKSHEET_POINTS,
          Calculations::Sum.groups(@group_points)
        load_results_row Translations::WORKSHEET_SPRINTS,
          @project.total_weeks, 4
        load_results_row Translations::WORKSHEET_PPW,
          @project.points_per_week, 0
      end

      def load_results_row(description, value, step = 1)
        col = @project.total_weeks + 4

        set_column_value col, description
        set_column_value col + 1, value
        advance_current_row step
      end

      def load_format
        formatter = Formatter.new
        requests = []
        total_weeks = @project.total_weeks

        requests << formatter.title(range(0, 1, 2, 3))
        requests << formatter.description(range(ROW_TITLE + 1,
            Translations::WORKSHEET_DESCRIPTION.count + 3,
            2, 3))
        requests << formatter.header(range(@header_row - 1,
                                           @header_row + 2,
                                           0, total_weeks + 3))
        requests << formatter.estimation_column(range(@story_row - 2,
                                                      @last_row - 1,
                                                      1, 2))

        @group_points.each do |row|
          requests << formatter.group_name(range(row - 1, row, 0, 1))
        end

        requests << formatter.delivered_cell(range(@story_row - 1,
                                                   @story_row,
                                                   total_weeks + 4,
                                                   total_weeks + 5))
        requests << formatter.in_progress_cell(range(@story_row,
                                                     @story_row + 1,
                                                     total_weeks + 4,
                                                     total_weeks + 5))
        requests << formatter.planned_cell(range(@story_row + 1,
                                                 @story_row + 2,
                                                 total_weeks + 4,
                                                 total_weeks + 5))
        requests << formatter.advanced_cell(range(@story_row + 2,
                                                  @story_row + 3,
                                                  total_weeks + 4,
                                                  total_weeks + 5))

        update_spreadsheet(requests)
      end

      def range(start_row, end_row, start_column, end_column)
        {
          sheet_id: SHEET_ID,
          start_row_index: start_row,
          end_row_index: end_row,
          start_column_index: start_column,
          end_column_index: end_column
        }
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

      def session(code)
        credentials.code = code
        credentials.fetch_access_token!
        GoogleDrive::Session.from_credentials(credentials)
      end

      def update_spreadsheet(requests)
        service = Google::Apis::SheetsV4::SheetsService.new
        service.authorization = credentials
        service.batch_update_spreadsheet(@spreadsheet.key,
                                         { requests: requests },
                                         {})
      end
    end
  end
end
