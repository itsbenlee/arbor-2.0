require 'spec_helper'

feature 'Copy project', js: true do
  background do
    @user = sign_in create :user
    @project = create :project, { owner: @user }
  end

  scenario 'should show a copy project link' do
    visit project_path(@project.id)

    within '.show-project-data' do
      expect(page).to have_css('a.copy-project')
    end
  end

  scenario 'should copy a project when the user click copy project' do
    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    expect(Project.count).to eq(2)
  end

  scenario 'should copy a project with name copy of project name' do
    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last
    expect(replica.name).to eq("Copy of #{@project.name} (#{@project.copies + 1})")
  end

  scenario 'should copy a project with an hypothesis' do
    create :hypothesis, project: @project

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last
    expect(replica.hypotheses.count).to eq(1)
  end

  scenario 'should copy a project with an hypothesis and check hypothesis data' do
    hypothesis = create :hypothesis, project: @project

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last
    expect(replica.hypotheses[0].description).to eq(hypothesis.description)
    expect(replica.hypotheses[0].hypothesis_type_id).to eq(hypothesis.hypothesis_type_id)
  end

  scenario 'should copy a new project with an hypothesis and check data on page' do
    hypothesis = create :hypothesis, project: @project

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_hypotheses_path(replica.id)

    within '.hypothesis-form' do
      expect(find('.description.hypothesis-show')).to have_text(hypothesis.description)
    end
  end

  scenario 'should copy a project with a goal and check data on page' do
    hypothesis = create :hypothesis, project: @project
    goal = create :goal, hypothesis: hypothesis

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_hypotheses_path(replica.id)

    within '.goals' do
      expect(find('.goal-title.goal-item')).to have_text(goal.title)
    end
  end

  scenario 'should copy a project with a user story and check data on page' do
    hypothesis = create :hypothesis, project: @project
    user_story = create :user_story, hypothesis: hypothesis, project: @project

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_hypotheses_path(replica.id)

    within 'form.edit-story.edit_user_story' do
      expect(find('#user_story_role').value).to have_text(user_story.role)
      expect(find('#user_story_action').value).to have_text(user_story.action)
      expect(find('#user_story_result').value).to have_text(user_story.result)
    end
  end

  scenario 'should copy a project with a user story without hypothesis and check data on page' do
    user_story = create :user_story, project: @project, hypothesis: nil

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_hypotheses_path(replica.id)

    within 'form.edit-story.edit_user_story' do
      expect(find('#user_story_role').value).to have_text(user_story.role)
      expect(find('#user_story_action').value).to have_text(user_story.action)
      expect(find('#user_story_result').value).to have_text(user_story.result)
    end
  end

  scenario 'should copy project with a user story, constraint and check data on page' do
    hypothesis = create :hypothesis, project: @project
    user_story = create :user_story, hypothesis: hypothesis, project: @project
    constraint = create :constraint, user_story: user_story

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_user_stories_path(replica.id)

    within '.user-stories ul' do
      find('li.user-story').click
    end

    within 'form.edit_constraint' do
      expect(find('textarea.constraint-input').value).to have_text(constraint.description)
    end
  end

  scenario 'should copy project with a user story, criterion and check data on page' do
    hypothesis = create :hypothesis, project: @project
    user_story = create :user_story, hypothesis: hypothesis, project: @project
    criterion = create :acceptance_criterion, user_story: user_story

    visit project_path(@project.id)

    within '.show-project-data' do
      find('a.copy-project').click
    end
    replica = Project.last

    visit project_user_stories_path(replica.id)

    within '.user-stories ul' do
      find('li.user-story').click
    end

    within 'form.edit_acceptance_criterion' do
      expect(find('textarea#acceptance_criterion_description').value).to have_text(criterion.description)
    end
  end
end
