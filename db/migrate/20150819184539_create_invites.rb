class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.string :email
      t.references :project, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
