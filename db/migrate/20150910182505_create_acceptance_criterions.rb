class CreateAcceptanceCriterions < ActiveRecord::Migration
  def change
    create_table :acceptance_criterions do |t|
      t.text :description
      t.references :user_story, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
