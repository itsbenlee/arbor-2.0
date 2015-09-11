require 'spec_helper'

RSpec.describe AcceptanceCriterion do
  let(:acceptance_criterion) { create :acceptance_criterion }
  subject    { acceptance_criterion }

  it { should validate_presence_of :description }
end
