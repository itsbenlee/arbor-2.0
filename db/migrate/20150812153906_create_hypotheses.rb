class CreateHypotheses < ActiveRecord::Migration
  def change
    create_table :hypotheses do |t|
      t.string     :description
      t.references :project, index: true
      t.references :hypothesis_type, index: true
      t.integer    :order

      t.timestamps
    end
  end
end
