module Google
  module SheetsV4
    class Calculations
      class Sum
        def self.row(chr_col, row, max_rows)
          "=SUMIF(#{chr_col}#{row}:#{chr_col}#{max_rows};\"-\";" \
          "B#{row}:#{chr_col}#{max_rows})"
        end

        def self.groups(group_points)
          range = group_points.map { |points| "B#{points}" }.join(';')
          "=SUM(#{range})"
        end

        def self.stories(row, stories)
          "=SUM(B#{row + 1}:B#{stories})"
        end
      end
    end
  end
end
