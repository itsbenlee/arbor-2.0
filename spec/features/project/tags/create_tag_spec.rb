require 'spec_helper'

feature 'Create tag', js: true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user }
  let!(:user_story) { create :user_story, project: project }

  background do
    sign_in user
  end

  context 'in the backlog' do
    background do
      visit project_user_stories_path project
      find('.user-story').click
      expect(page).to have_content "STORY ##{user_story.story_number}"
    end

    scenario 'should create a tag' do
      fill_in :tag_name, with: 'MyTag'
      find('input#save-tag', visible: false).trigger('click')
      visit current_path

      expect(Tag.count).to eq 1
      tag = Tag.first
      expect(tag.name).to eq('MyTag')
      expect(tag.project).to eq(project)
      expect(tag.user_stories.first).to eq(user_story)
      expect(user_story.tags.first).to eq(tag)
    end
  end

  context 'with tags' do
    let!(:tag) { create :tag, name: 'MyTag', project: project }

    background do
      visit project_user_stories_path project
      find('.user-story').click
      expect(page).to have_content "STORY ##{user_story.story_number}"
      expect(user_story.reload.tags.count).to eq 0
      check 'MyTag'
      expect { user_story.reload.tags.count }.to become_eq 1
    end

    scenario 'should assign them to user stories' do
      expect{ user_story.reload.tags.first }.to become_eq tag
    end

    scenario 'should not accept duplicates' do
      fill_in :tag_name, with: 'MyTag'
      find('input#save-tag', visible: false).trigger('click')
      expect(page).to have_content('Name has already been taken')
    end
  end
end
