require 'spec_helper'

RSpec.describe Goal do
  let(:goal) { create :goal }
  subject    { goal }

  it { should validate_presence_of :title }
  it { should belong_to(:hypothesis) }
end
