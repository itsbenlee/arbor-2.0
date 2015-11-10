require 'spec_helper'

RSpec.describe Comment do
  let(:comment) { create :comment }
  subject       { comment }

  it { should validate_presence_of :comment }
  it { should belong_to :user }
end
