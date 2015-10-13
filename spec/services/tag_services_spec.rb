require 'spec_helper'

feature 'create tag' do
  let(:project)     { create :project }
  let(:user_story)  { create :user_story, project: project }
  let(:tag_service) { TagServices.new(user_story) }
  let(:tag_params)  { { name: 'My new tag' } }

  scenario 'should create a Tag and add the user story' do
    response = tag_service.new_tag(tag_params)
    expect(response.success).to eq(true)
    tag = Tag.last
    expect(tag).to be_a(Tag)
    expect(tag.name).to eq('My new tag')
    expect(tag.user_stories.first).to eq(user_story)
    expect(tag.project).to eq(project)
  end
end
