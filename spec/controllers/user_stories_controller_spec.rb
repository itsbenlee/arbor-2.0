require 'spec_helper'


RSpec.describe UserStoriesController do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:hypothesis)  { create :hypothesis, project: project }

  before :each do
    sign_in user
    @first_story, @second_story, @third_story = set_user_stories(hypothesis)
  end

  describe 'PUT update order' do
    context 'in one hypothesis' do
      it 'should reorder user stories' do
        stories =  { '0' => { id: @first_story.id, order: 2 },
                     '1' => { id: @second_story.id, order: 3 },
                     '2' => { id:@third_story.id, order: 1 } }

        put :update_order, project_id: project.id,
        hypotheses: { '0' => { id: hypothesis.id, stories: stories }}

        first_story_updated, second_story_updated, third_story_updated =
          get_reordered(@first_story, @second_story, @third_story)

        expect(first_story_updated.order).to be(2)
        expect(second_story_updated.order).to be(3)
        expect(third_story_updated.order).to be(1)
      end
    end

    context 'in many hypotheses' do
      it 'should move of hypothesis and reorder user stories' do
        second_hypothesis = create :hypothesis, project: project
        first_hypothesis_stories = { '0' => { id: @first_story.id, order: 2 },
                                     '1' => { id: @second_story.id, order: 1 } }
        second_hypothesis_stories = { '0' => { id: @third_story.id, order: 1 } }

        put :update_order, project_id: project.id,
            hypotheses: { '0' => { id: hypothesis.id,
                                   stories: first_hypothesis_stories },
                          '1' => { id: second_hypothesis.id,
                                   stories: second_hypothesis_stories }
            }
        first_story_updated, second_story_updated, third_story_updated =
          get_reordered(@first_story, @second_story, @third_story)

        expect(first_story_updated.order).to eq 2
        expect(first_story_updated.hypothesis_id).to eq hypothesis.id
        expect(second_story_updated.order).to eq 1
        expect(second_story_updated.hypothesis_id).to eq hypothesis.id
        expect(third_story_updated.order).to eq 1
        expect(third_story_updated.hypothesis_id).to eq second_hypothesis.id
      end
    end
  end
end
