module Google
  module SheetsV4
    class Formatter
      COLOR_ADVANCED = { red: 0.956, green: 0.8, blue: 0.8 }
      COLOR_DELIVER  = { red: 0.576, green: 0.768, blue: 0.490 }
      COLOR_HEADER   = { red: 0.85, green: 0.85, blue: 0.85 }
      COLOR_PLAN     = { red: 1, green: 0.949, blue: 0.8 }
      COLOR_PROGRESS = { red: 0.788, green: 0.854, blue: 0.972 }
      COLOR_DEFAULT  = { red: 0.0, green: 0.0, blue: 0.0 }

      FORMAT_T   = 'userEnteredFormat.textFormat'
      FORMAT_AT  = 'userEnteredFormat(horizontalAlignment,textFormat)'
      FORMAT_BT  = 'userEnteredFormat(borders,textFormat)'
      FORMAT_CT  = 'userEnteredFormat(backgroundColor,textFormat)'
      FORMAT_CAT =
        'userEnteredFormat(backgroundColor,horizontalAlignment,textFormat)'

      def title
        {
          repeat_cell: {
            range: range(0, 1, 2, 3),
            cell: { user_entered_format: { text_format: { bold: true } } },
            fields: FORMAT_T
          }
        }
      end

      def header(start_row, end_row, start_column, end_column)
        {
          repeat_cell: {
            range: range(start_row, end_row, start_column, end_column),
            cell: {
              user_entered_format: {
                background_color: COLOR_HEADER,
                text_format: { bold: true }
              }
            },
            fields: FORMAT_CT
          }
        }
      end

      def description
        {
          repeat_cell: {
            range: range(Google::SheetsV4::ExportService::ROW_TITLE + 1,
                I18n.t('google_sheets.worksheet.description').count + 3, 2, 3),
            cell: {
              user_entered_format: {
                text_format: { italic: true, font_size: 8 }
              }
            },
            fields: FORMAT_T
          }
        }
      end

      def group_name(row)
        {
          repeat_cell: {
            range: range(row - 1, row, 0, 1),
            cell: {
              user_entered_format: {
                background_color: COLOR_HEADER,
                text_format: { bold: true }
              }
            },
            fields: FORMAT_CT
          }
        }
      end

      def estimation_column(start_row, end_row)
        {
          repeat_cell: {
            range: range(start_row, end_row, 1, 2),
            cell: {
              user_entered_format: {
                borders: { right: { style: 'SOLID', color: COLOR_DEFAULT } },
                text_format: { bold: true }
              }
            },
            fields: FORMAT_BT
          }
        }
      end

      def delivered_cell(start_row, end_row, start_column, end_column)
        {
          repeat_cell: {
            range: range(start_row, end_row, start_column, end_column),
            cell: {
              user_entered_format: {
                horizontal_alignment: 'CENTER',
                text_format: {
                  foreground_color: COLOR_DELIVER,
                  font_family: 'Verdana', font_size: 11, bold: true
                }
              }
            },
            fields: FORMAT_AT
          }
        }
      end

      def in_progress_cell(start_row, end_row, start_column, end_column)
        {
          repeat_cell: {
            range: range(start_row, end_row, start_column, end_column),
            cell: {
              user_entered_format: {
                background_color: COLOR_PROGRESS,
                horizontal_alignment: 'CENTER',
                text_format: { bold: true }
              }
            },
            fields: FORMAT_CAT
          }
        }
      end

      def planned_cell(start_row, end_row, start_column, end_column)
        {
          repeat_cell: {
            range: range(start_row, end_row, start_column, end_column),
            cell: {
              user_entered_format: {
                background_color: COLOR_PLAN,
                horizontal_alignment: 'CENTER',
                text_format: { bold: true }
              }
            },
            fields: FORMAT_CAT
          }
        }
      end

      def advanced_cell(start_row, end_row, start_column, end_column)
        {
          repeat_cell: {
            range: range(start_row, end_row, start_column, end_column),
            cell: {
              user_entered_format: {
                background_color: COLOR_ADVANCED,
                horizontal_alignment: 'CENTER',
                text_format: { bold: true }
              }
            },
            fields: FORMAT_CAT
          }
        }
      end

      private

      def range(start_row, end_row, start_column, end_column)
        {
          sheet_id: Google::SheetsV4::ExportService::SHEET_ID,
          start_row_index: start_row,
          end_row_index: end_row,
          start_column_index: start_column,
          end_column_index: end_column
        }
      end
    end
  end
end
