class AddValueFieldToActivities < ActiveRecord::Migration
  def change
    change_table :activities do |t|
      t.string :value, index: true
    end
  end
end
