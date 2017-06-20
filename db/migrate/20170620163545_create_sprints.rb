class CreateSprints < ActiveRecord::Migration
  def change
    create_table :sprints do |t|
      t.references :project, index: true, foreign_key: true, null: false

      t.timestamps null: false
    end
  end
end
