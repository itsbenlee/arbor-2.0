require 'spec_helper'

def add_hypothesis(project, quantity)
  hypotheses = []
  quantity.times { hypotheses.push(create :hypothesis, { project: project }) }
  hypotheses
end

describe Hypothesis do
  let(:hypothesis) { create :hypothesis }

  it { should validate_presence_of :description }
  it { should validate_presence_of :project }
  it { should validate_presence_of :hypothesis_type }
  it { should belong_to :project }
  it { should belong_to :hypothesis_type }

  it 'must increase hypothesis order' do
    project = create :project

    hypotheses = add_hypothesis(project, 10)
    hypotheses.each_with_index do |hypothesis, index|
      expect(hypothesis.order).to be(index + 1)
    end
  end
end
