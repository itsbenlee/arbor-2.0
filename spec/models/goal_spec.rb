require 'spec_helper'

RSpec.describe Goal do
  let(:goal) { create :goal }
  subject    { goal }

  it { should validate_presence_of :title }
  it { should belong_to(:hypothesis) }

  it_behaves_like 'a logged entity' do
    let(:entity)      { build :goal, title: 'Test goal' }
    let(:description) { 'Test goal' }
  end
end
