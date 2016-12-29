require "googleauth"
require "google_drive"
require 'google/apis/sheets_v4'

module ArborReloaded
  class GoogleSheetsServices
    TITLE_ROW = 1

    def initialize(project, redirect_uri)
      @project = project
      @redirect_uri = redirect_uri
      @common_response = CommonResponse.new(true, [])
    end

    def google_sheets_authentication_url
      setup_credentials.authorization_uri.to_s
    end

    def export(code)
      session = setup_session(code)
      @spreadsheet = session.create_spreadsheet @project.name
      @ws = @spreadsheet.worksheets[0]
      @current_row = TITLE_ROW

      write_title_and_description

      @header_row = step_row(1)
      @initial_stories_row = @header_row + 4
      write_header

      @current_row = @initial_stories_row
      @group_points_rows = []

      write_ungrouped_user_stories unless @project.user_stories.ungrouped.empty?
      write_groups_with_stories
      @last_row = @current_row
      write_results_table

      @ws.synchronize
      @common_response.data[:spreadsheet_id] = @spreadsheet.key

      @common_response
    rescue => error
      process_error(error)
      @common_response
    end

    private

    def process_error(error)
      @common_response.success = false
      @common_response.errors = I18n.t('google_sheets.modal.error')
    end

    def setup_credentials
      Google::Auth::UserRefreshCredentials.new(
        client_id: ENV['GOOGLE_SHEETS_CLIENT_ID'],
        client_secret: ENV['GOOGLE_SHEETS_CLIENT_SECRET'],
        scope: [
          "https://www.googleapis.com/auth/drive",
          "https://spreadsheets.google.com/feeds/",
        ],
        state: @project.id,
        redirect_uri: @redirect_uri)
    end

    def setup_session(code)
      @credentials = setup_credentials
      @credentials.code = code
      @credentials.fetch_access_token!
      GoogleDrive::Session.from_credentials(@credentials)
    end

    def write_title_and_description
      @ws[@current_row, 3] = I18n.t('google_sheets.worksheet.title')
      step_row(2)
      I18n.t('google_sheets.worksheet.description').each do |item|
        @ws[@current_row, 3] = item
        step_row(1)
      end
    end

    def write_header
      @ws[@header_row, 1] = I18n.t('google_sheets.worksheet.header')
      @ws[@header_row + 2, 2] = I18n.t('google_sheets.worksheet.complexity')

      (0..@project.total_weeks).each do |sprint_number|
        sprint_column = sprint_number + 3
        @ws[@header_row, sprint_column] = "#{I18n.t('google_sheets.worksheet.sprint_header')} #{sprint_number}"
        column_character = (sprint_number + 67).chr
        formula = "=SUMIF(#{column_character}#{@initial_stories_row}:#{column_character}#{@ws.max_rows}, \"-\", B#{@initial_stories_row}:#{column_character}#{@ws.max_rows})"
        @ws[@header_row + 2, sprint_column] = formula unless sprint_number == 0
      end
    end

    def write_ungrouped_user_stories
      @ws[@current_row, 1] = I18n.t('google_sheets.worksheet.ungrouped')
      formula = "=SUM(B#{@current_row + 1 }:B#{@current_row + @project.user_stories.ungrouped.count})"
      @ws[@current_row, 2] = formula
      @group_points_rows.push(@current_row)

      step_row(1)
      write_user_stories @project.user_stories.ungrouped
      step_row(1)
    end

    def write_groups_with_stories
      @project.groups.each do |group|
        @ws[@current_row, 1] = group.name
        formula = "=SUM(B#{@current_row + 1 }:B#{@current_row + (group.user_stories.any? ? group.user_stories.count : 1)})"
        @ws[@current_row, 2] = formula
        @group_points_rows.push(@current_row)

        step_row(1)
        write_user_stories group.user_stories
        step_row(1)
      end
    end

    def write_user_stories(user_stories)
      user_stories.each do |user_story|
        @ws[@current_row, 1] = user_story.log_description
        @ws[@current_row, 2] = user_story.estimated_points
        step_row(1)
      end
    end

    def write_results_table
      first_column = @project.total_weeks + 4
      @current_row = @initial_stories_row

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.delivered')
      @ws[@current_row, first_column + 1] = '√'
      step_row(1)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.in_progress')
      @ws[@current_row, first_column + 1] = '-'
      step_row(1)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.planned')
      @ws[@current_row, first_column + 1] = '-'
      step_row(1)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.advanced')
      @ws[@current_row, first_column + 1] = '-'
      step_row(1)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.points')
      @ws[@current_row, first_column + 1] = "=SUM(#{@group_points_rows.map{|p| "B#{p}"}.join(',')})"
      step_row(1)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.sprints')
      @ws[@current_row, first_column + 1] = @project.total_weeks + 1
      step_row(4)

      @ws[@current_row, first_column] = I18n.t('google_sheets.worksheet.ppw')
      @ws[@current_row, first_column + 1] = "=#{(first_column + 65).chr}#{@current_row - 5}/#{(first_column + 65).chr}#{@current_row - 4}"
    end

    def step_row(step)
      @current_row += step
    end
  end
end
