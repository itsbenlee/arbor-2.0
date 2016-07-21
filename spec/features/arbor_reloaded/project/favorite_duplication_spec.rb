require 'spec_helper'

feature 'Project duplication', js: true do
  let!(:user)       { create :user }
  let!(:project)    { create :project, owner: user, favorite: true }
  let!(:user_story) { create :user_story, project: project }
  let!(:criterion)  { create :acceptance_criterion, user_story: user_story }
  let!(:comment)    { create :comment, user_story: user_story }

  background do
    sign_in user
    visit arbor_reloaded_root_path
    within '.favorite-project' do
      find('.others').click
      find('.copy-project').click
      wait_for_ajax
    end
  end

  context 'check project duplication' do
    scenario 'the project is created on database' do
      expect(Project.last.name).to eq("Copy of #{project.name} (1)")
    end

    scenario 'if you visit the projects page you can see the duplicated project' do
      click_link 'Projects'
      expect(page).to have_content("Copy of #{project.name} (1)")
    end
  end

  context 'check user story duplication' do
    background do
      duplicated_project = Project.find_by_name("Copy of #{project.name} (1)")
      @duplicated_story = duplicated_project.user_stories.first
    end

    scenario 'the user story action is duplicated' do
      expect(@duplicated_story.action).to eq(user_story.action)
    end

    scenario 'the user story role is duplicated' do
      expect(@duplicated_story.role).to eq(user_story.role)
    end

    scenario 'the user story result is duplicated' do
      expect(@duplicated_story.result).to eq(user_story.result)
    end

    scenario 'the user story estimated points amount is duplicated' do
      expect(@duplicated_story.estimated_points).to eq(user_story.estimated_points)
    end

    scenario 'the user story description is duplicated' do
      expect(@duplicated_story.description).to eq(user_story.description)
    end
  end

  context 'for acceptance criterions duplication' do
    background do
      duplicated_project = Project.find_by_name("Copy of #{project.name} (1)")
      duplicated_story = duplicated_project.user_stories.first
      @duplicated_criterion = duplicated_story.acceptance_criterions.first
    end

    scenario 'the description is duplicated' do
      expect(@duplicated_criterion.description).to eq(criterion.description)
    end
  end

  context 'for comments duplication' do
    background do
      duplicated_project = Project.find_by_name("Copy of #{project.name} (1)")
      duplicated_story = duplicated_project.user_stories.first
      @duplicated_comment = duplicated_story.comments.first
    end

    scenario 'the comment is duplicated' do
      expect(@duplicated_comment.comment).to eq(comment.comment)
    end

    scenario 'the user who comments is duplicated' do
      expect(@duplicated_comment.user).to eq(comment.user)
    end
  end
end
