require 'csv'

class HypothesisServices
  def initialize(project = Project.new)
    @project = project
    @hypotheses = project.hypotheses
  end

  def csv_export
    Hypothesis.to_csv(@hypotheses)
  end

  def json_export
    HypothesisServices.add_hypotheses(@project.as_json, @hypotheses)
  end

  def reorder_stories(new_order)
    response = { success: true }
    new_order.values.each do |hypothesis_hash|
      @hypotheses
        .find(hypothesis_hash['id'])
        .reorder_user_stories(hypothesis_hash['stories'])
    end
    response
  end

  def self.add_hypotheses(json_project, hypotheses)
    json_project[:hypotheses] = []

    hypotheses.each do |hypothesis|
      json_project.symbolize_keys!
      json_project[:hypotheses].push(hypothesis.as_json)
    end

    json_project.to_json
  end
end
