require 'spec_helper'

RSpec.describe Constraint do
  let(:constraint) { create :constraint }
  subject          { constraint }

  it { should validate_presence_of :description }
end
