require 'spec_helper'

RSpec.describe UserStory do
  let(:project)     { create :project }
  let(:hypothesis)  { create :hypothesis, project: project}
  let(:user_story)  { create :user_story, hypothesis: hypothesis }
  subject           { user_story }

  it { should validate_presence_of :role }
  it { should validate_presence_of :action }
  it { should validate_presence_of :result }
  it { should validate_inclusion_of(:priority).in_array %w(m s c w) }
  it { should belong_to(:project) }

  it 'must increase user stories order' do
    hypothesis_ordered = create :hypothesis, project: project

    user_stories = create_list :user_story, 3, hypothesis: hypothesis
    user_stories.each_with_index do |user_story, index|
      expect(user_story.order).to be(index + 1)
    end
  end
end
