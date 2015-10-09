require 'spec_helper'

RSpec.describe Constraint do
  let(:constraint) { create :constraint }
  subject          { constraint }

  it { should validate_presence_of :description }
  it { should validate_uniqueness_of(:description).scoped_to(:user_story_id) }
  it { should belong_to :user_story }
end
