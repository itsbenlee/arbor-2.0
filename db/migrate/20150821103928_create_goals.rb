class CreateGoals < ActiveRecord::Migration
  def change
    create_table :goals do |t|
      t.text :title, null:false
      t.references :hypothesis, index: true
      t.timestamps
    end
  end
end
