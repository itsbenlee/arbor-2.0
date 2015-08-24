require 'csv'

class HypothesisServices
  def initialize(project = Project.new)
    @project = project
    @hypotheses = project.hypotheses
  end

  def csv_export
    Hypothesis.to_csv(@hypotheses)
  end
end
