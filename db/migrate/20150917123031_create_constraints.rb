class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.string  :description, limit: 255, null: false, index: true
      t.references :user_story, null: false, index: true

      t.timestamps null: false
    end
  end
end
