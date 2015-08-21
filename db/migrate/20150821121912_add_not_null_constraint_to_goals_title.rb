class AddNotNullConstraintToGoalsTitle < ActiveRecord::Migration
  def change
    change_column_null :goals, :title, false
  end
end
