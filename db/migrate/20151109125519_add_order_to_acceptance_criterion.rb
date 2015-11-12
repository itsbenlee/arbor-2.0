class AddOrderToAcceptanceCriterion < ActiveRecord::Migration
  def change
    add_column :acceptance_criterions, :order, :integer, index: true
  end

  def data
    i = 1
    AcceptanceCriterion.all.order(created_at: :asc).each do |acceptance_criterion|
      acceptance_criterion.order = i
      acceptance_criterion.save
      i += 1
    end
  end
end
