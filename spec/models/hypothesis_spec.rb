require 'spec_helper'

describe Hypothesis do
  let(:hypothesis) { create :hypothesis }
  let(:project)    { create :project }
  subject          { hypothesis }

  it { should validate_presence_of :description }
  it { should validate_presence_of :project }
  it { should belong_to :project }
  it { should belong_to :hypothesis_type }

  it 'must increase hypothesis order' do
    hypotheses = create_list :hypothesis, 3, project: project
    hypotheses.each_with_index do |hypothesis, index|
      expect(hypothesis.order).to be(index + 1)
    end
  end

  it_behaves_like 'a logged entity' do
    let(:entity)      { build :hypothesis, description: 'This is a test' }
    let(:description) { 'This is a test' }
  end
end
