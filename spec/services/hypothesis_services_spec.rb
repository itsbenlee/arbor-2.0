require 'spec_helper'

feature 'Reorder user stories' do
  let!(:user)        { create :user }
  let!(:project)     { create :project, owner: user }
  let!(:hypothesis)  { create :hypothesis, project: project }

  background do
    sign_in user
    @first_story, @second_story, @third_story = set_user_stories(hypothesis)
  end

  scenario 'should reorder user stories on hypothesis' do
    stories =  { '0' => {'id' => @first_story.id, 'order' => 2},
                 '1' => {'id' => @second_story.id, 'order' => 3},
                 '2' => {'id' => @third_story.id, 'order' => 1} }

    hypothesis_services = HypothesisServices.new(project)
    hypothesis_services.reorder_stories({ '0' => { 'id' => hypothesis.id,
                                                   'stories' => stories }})

    first_story_updated, second_story_updated, third_story_updated =
      get_reordered(@first_story, @second_story, @third_story)

    expect(first_story_updated.order).to eq 2
    expect(second_story_updated.order).to eq 3
    expect(third_story_updated.order).to eq 1
  end

  scenario 'should reorder user stories on hypothesis' do
    second_hypothesis = create :hypothesis, project: project
    first_hypothesis_stories = { '0' => {'id' => @first_story.id, 'order' => 2},
                                 '1' => {'id' => @second_story.id, 'order' => 1} }
    second_hypothesis_stories = { '0' => {'id' => @third_story.id, 'order' => 1} }

    hypothesis_services = HypothesisServices.new(project)
    hypothesis_services.reorder_stories({ '0' => {'id' => hypothesis.id,
                                                  'stories' => first_hypothesis_stories},
                                          '1' => {'id' => second_hypothesis.id,
                                                  'stories' => second_hypothesis_stories}})

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
