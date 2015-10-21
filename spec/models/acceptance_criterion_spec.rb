require 'spec_helper'

RSpec.describe AcceptanceCriterion do
  let(:acceptance_criterion) { create :acceptance_criterion }
  subject                    { acceptance_criterion }

  it { should validate_presence_of :description }
  it { should validate_uniqueness_of(:description).scoped_to(:user_story_id) }
  it { should belong_to :user_story }
end
