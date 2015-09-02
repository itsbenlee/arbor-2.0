require 'spec_helper'

def set_new_order(first_hypothesis, second_hypothesis)
  first_hypothesis_ordered = {
    id: first_hypothesis.id,
    order: 2
  }

  second_hypothesis_ordered = {
    id: second_hypothesis.id,
    order: 1
  }

  { 0 => second_hypothesis_ordered, 1 => first_hypothesis_ordered }
end

feature 'Reorder hypothesis inside' do
  background do
    @user = sign_in create :user
    @project = create :project, { owner: @user, members: [@user]}
  end

  scenario 'should use the new order for hypothesis' do
    first_hypothesis = create :hypothesis, { project: @project }
    second_hypothesis = create :hypothesis, { project: @project }
    new_order = set_new_order(first_hypothesis, second_hypothesis)

    project_services = ProjectServices.new(@project)
    project_services.reorder_hypotheses(new_order)

    updated_first_hypothesis = Hypothesis.find(first_hypothesis.id)
    updated_second_hypothesis = Hypothesis.find(second_hypothesis.id)
    expect(updated_first_hypothesis.order).to eq 2
    expect(updated_second_hypothesis.order).to eq 1
  end
end
