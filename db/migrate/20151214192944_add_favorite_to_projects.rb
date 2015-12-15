class AddFavoriteToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :favorite, :boolean, default: false
  end
end
