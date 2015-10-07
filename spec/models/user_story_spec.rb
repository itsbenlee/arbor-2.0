require 'spec_helper'

RSpec.describe UserStory do
  let(:project)     { create :project }
  let(:hypothesis)  { create :hypothesis, project: project}
  let(:user_story)  { create :user_story, hypothesis: hypothesis }
  subject           { user_story }

  it { should validate_presence_of :role }
  it { should validate_presence_of :action }
  it { should validate_presence_of :result }
  it { should validate_inclusion_of(:priority).in_array UserStory::PRIORITIES }
  it { should have_many :acceptance_criterions }
  it { should have_many :constraints }
  it { should belong_to(:project) }
  it { should have_many :acceptance_criterions }
  it { should have_many :constraints }
  it { should have_and_belong_to_many(:tags) }
  it { should validate_uniqueness_of(:story_number).scoped_to(:project_id)}

  it 'must increase user stories order' do
    user_stories = create_list :user_story, 3, hypothesis: hypothesis
    user_stories.each_with_index do |user_story, index|
      expect(user_story.order).to be(index + 1)
    end
  end

  it 'must increment user story number' do
    test_project = create :project
    user_stories = create_list :user_story, 3, project: test_project
    user_stories.each_with_index do |user_story, index|
      expect(user_story.story_number).to eq(index + 1)
    end
  end

  it 'must increase user stories backlog order' do
    user_stories = create_list :user_story, 3, project: project
    user_stories.each_with_index do |user_story, index|
      expect(user_story.backlog_order).to be(index + 1)
    end
  end

  it_behaves_like 'a logged entity' do
    let(:entity) do
      build :user_story, role: 'User', action: 'work', result: 'test'
    end
    let(:description) { 'As a User I should be able to work so that test' }
  end

  describe 'story_number' do
    it 'should assign unique story numbers' do
      user_stories = create_list :user_story, 2, project: project

      expect(user_stories.first.story_number).to eq 1
      expect(user_stories.second.story_number).to eq 2

      user_stories.second.destroy

      next_story = create :user_story, project: project
      expect(next_story.story_number).to eq 3
    end
  end
end
