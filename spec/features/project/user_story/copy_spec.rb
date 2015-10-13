require 'spec_helper'

feature 'Copy project', js: true do
  background do
    @user            = create :user
    @project         = create :project, { owner: @user }
    @another_project = create :project, { owner: @user }
    @user_story      = create :user_story, { project: @project }
    sign_in @user
    visit project_user_stories_path(@project.id)
  end

  scenario 'should display an error message when there are not user stories selected' do
    within '#top-nav' do
      find('a#select_stories_lnk').click
      find('a#copy_stories_lnk').click
    end

    within '#copy_stories_modal' do
      find('#copy_stories_submit').click
      expect(page).to have_css '.copy-stories-error'
      expect(find('.copy-stories-error').text).to have_text I18n.t('backlog.user_stories.no_stories')
    end
  end

  scenario 'should copy user story on another project' do
    within '#top-nav' do
      find('a#select_stories_lnk').click
    end

    within '.copy-story-check-box' do
      find("#user_story_#{@user_story.id}", visible: false).trigger(:click)
    end

    within '#top-nav' do
      find('a#copy_stories_lnk').click
    end

    within '#copy_stories_modal' do
      select @another_project.name, from: 'copy_story_project_id'
      find('#copy_stories_submit').click
    end

    visit project_user_stories_path(@another_project.id)
    within '.user-stories-list-container li.user-story' do
      expect(page).to have_text @user_story.role
      expect(page).to have_text @user_story.action
      expect(page).to have_text @user_story.result
    end
  end
end
