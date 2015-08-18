require 'spec_helper'

RSpec.describe UserStory do
  let(:user_story) { create :user_story }
  subject    { user_story }

  it { should validate_presence_of :role }
  it { should validate_presence_of :action }
  it { should validate_presence_of :result }
  it { should validate_inclusion_of(:priority).in_array %w(m s c w) }
  it { should belong_to(:project) }
end
