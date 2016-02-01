class AddIsTemplateToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :is_template, :boolean, default: false
  end
end
