class UpdateAccessToken < ActiveRecord::Migration
  def change
    User.all.each(&:touch)
  end
end
