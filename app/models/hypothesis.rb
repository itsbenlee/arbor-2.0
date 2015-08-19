class Hypothesis < ActiveRecord::Base
  validates_presence_of :description, :hypothesis_type, :project
  validates_uniqueness_of :description, scope: :project_id
  validates_uniqueness_of :order, scope: :project_id
  before_create :order_in_project

  belongs_to :project
  belongs_to :hypothesis_type
  delegate :description, :code, to: :hypothesis_type, prefix: true

  def self.new_order(hypothesis_hash)
    hypothesis = Hypothesis.find(hypothesis_hash[:id])
    hypothesis.order = hypothesis_hash[:order]
    hypothesis.save
  end

  private

  def order_in_project
    if (project.hypotheses.count == 0)
      self.order = 1
    else
      self.order = Hypothesis.where(project_id: project_id).maximum(:order) + 1
    end
  end
end
