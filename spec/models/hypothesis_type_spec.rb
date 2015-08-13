require 'spec_helper'

describe HypothesisType do
  let(:hypothesis_type) { create :hypothesis_type }

  it { should validate_presence_of :code }
  it { should validate_presence_of :description }
  it { should validate_uniqueness_of :code }
  it { should validate_uniqueness_of :description }
  it { should have_many :hypotheses }
end
