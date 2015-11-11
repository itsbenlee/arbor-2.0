class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :title, :limit => 50, :default => ''
      t.text :comment
      t.references :commentable, :polymorphic => true
      t.references :user
      t.string :role, :default => 'comments'

      t.timestamps null: false
    end

    add_index :comments, :commentable_type
    add_index :comments, :commentable_id
    add_index :comments, :user_id
  end
end
