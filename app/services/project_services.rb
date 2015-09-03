class ProjectServices
  def initialize(project)
    @project = project
  end

  def reorder_hypotheses(hypotheses)
    response = { success: true }
    if clean_hypotheses_order
      hypotheses.each do |_index, hypothesis|
        new_order = Hypothesis.new_order(hypothesis.symbolize_keys)
        response[:success] = false unless new_order
      end
    end
    response
  end

  def reorder_stories(new_order)
    @project
      .reorder_user_stories(new_order)

    { success: true }
  end

  private

  def clean_hypotheses_order
    @project.hypotheses.update_all(order: nil)
    @project.save
  end
end
