class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string  :name, limit: 255, null: false, index: true
      t.references :owner, null: false, index: true

      t.timestamps
    end
  end
end
