class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :content, index: true, null: false
      t.string :thumbnail, index: true
      t.string :table_type, index: true
      t.references :project, index: true, foreign_key: true
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
