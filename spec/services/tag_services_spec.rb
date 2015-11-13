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

  scenario 'should create two Tags and add them to the user story and then delete the first one' do
    tag_params = { name: 'First tag' }
    response = tag_service.new_tag(tag_params)
    expect(response.success).to eq(true)

    tag_params = { name: 'Second tag' }
    response = tag_service.new_tag(tag_params)
    expect(response.success).to eq(true)

    tag = Tag.first
    tag2 = Tag.last

    expect(tag).to be_a(Tag)
    expect(tag.name).to eq('First tag')
    expect(tag.user_stories.first).to eq(user_story)
    expect(tag.project).to eq(project)

    expect(tag2).to be_a(Tag)
    expect(tag2.name).to eq('Second tag')
    expect(tag2.user_stories.first).to eq(user_story)
    expect(tag2.project).to eq(project)

    response = tag_service.delete_tag(tag.id)
    expect(response.success).to eq(true)

    expect(user_story.tags.size).to eq(1)
    expect(user_story.tags.last.id).to eq(tag2.id)
    expect(Tag.all.size).to eq(1)
    expect(Tag.last.id).to eq(tag2.id)
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
