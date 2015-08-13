require 'spec_helper'

describe Project do
  let(:project) { create :project }
  subject       { project }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should have_many :members }
  it { should have_many :hypotheses }
  it { should belong_to :owner }
end
