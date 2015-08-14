class CreateCanvas < ActiveRecord::Migration
  def change
    create_table :canvas do |t|
      t.text :problems
      t.text :solutions
      t.text :alternative
      t.text :advantage
      t.text :segment
      t.text :channel
      t.text :value_proposition, index: true
      t.text :revenue_streams
      t.text :cost_structure
      t.references :project, index: true

      t.timestamps
    end
  end
end
