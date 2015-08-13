class Hypothesis < ActiveRecord::Base
  validates_presence_of :description, :hypothesis_type, :project
  validates_uniqueness_of :description, scope: :project_id
  validates_uniqueness_of :order, scope: :project_id
  before_create :order_in_project

  belongs_to :project
  belongs_to :hypothesis_type
  delegate :description, :code, to: :hypothesis_type, prefix: true

  private

  def order_in_project
    if (project.hypotheses.count == 0)
      self.order = 1
    else
      self.order = Hypothesis.maximum(:order, group: project) + 1
    end
  end
end
