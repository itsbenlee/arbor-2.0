class CreateHypothesisTypes < ActiveRecord::Migration
  def change
    create_table :hypothesis_types do |t|
      t.string :code
      t.string :description

      t.timestamps
    end
  end
end
