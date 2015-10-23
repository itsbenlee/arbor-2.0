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

feature 'new tag search' do
  let(:project)       { create :project }
  let(:other_project) { create :project }
  let(:tag_service)   { TagServices.new }
  let!(:tag)           { create :tag, project: project }
  let!(:another_tag)   { create :tag, project: other_project }

  scenario 'should return the project tags' do
    response = tag_service.tag_search(project)
    expect(response.success).to eq(true)

    expect(response.data[:tags]).to have_text([tag.name])
    expect(response.data[:tags]).not_to have_text([another_tag.name])
  end
end
