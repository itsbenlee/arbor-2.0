require 'spec_helper'

RSpec.describe UserStoriesController do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:hypothesis)  { create :hypothesis, project: project }

  before :each do
    sign_in user
  end

  describe 'PUT update' do
    let!(:user_story) {
      create :user_story,
      project: project,
      role: 'user',
      action: 'sign up',
      result: 'i can browse the site',
      estimated_points: '3',
      priority: 'should',
      epic: 'false'
    }

    it 'send a success response with the edit url' do
      request.env['HTTP_REFERER'] = project_user_stories_path(project.id)
      put :update, id: user_story.id, user_story: {
          role: 'admin',
          action: 'sign up',
          result: 'i can browse the database',
          estimated_points: '3',
          priority: 'should',
          epic: 'false'
        }

      expect(UserStory.count).to eq(1)
      user_story = UserStory.last
      hash_response = JSON.parse(response.body)

      expect(hash_response['success']).to eq(true)
      expect(hash_response['data']['edit_url']).to eq(edit_user_story_path(user_story))
    end
  end

  describe 'POST create' do
    it 'send a success response with user story id' do
      request.env['HTTP_REFERER'] = project_hypotheses_path(project.id)
      post :create, project_id: project.id, user_story: {
          role: 'user',
          action: 'sign up',
          result: 'i can browse the site',
          estimated_points: '3',
          priority: 'should',
          hypothesis_id: hypothesis.id,
          epic: 'false'
        }

      expect(UserStory.count).to eq(1)
      user_story = UserStory.last
      hash_response = JSON.parse(response.body)

      expect(hash_response['success']).to eq(true)
      expect(hash_response['data']['user_story_id']).to eq(user_story.id)
    end

    context 'with ordering' do
      before :each do
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

            expect(first_story_updated.order).to eq 2
            expect(second_story_updated.order).to eq 3
            expect(third_story_updated.order).to eq 1
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
  end
end
