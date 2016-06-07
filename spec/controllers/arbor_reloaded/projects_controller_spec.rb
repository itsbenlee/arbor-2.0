require 'spec_helper'

RSpec.describe ArborReloaded::ProjectsController do
  let!(:user)   { create :user }
  let(:project) { create :project, owner: user, favorite: false }
  let(:team)    { create :team, users: [user] }

  before :each do
    sign_in user
  end

  describe 'PUT add member' do
    let!(:user2) { create :user }
    let!(:user3) { create :user }

    before :each do
      project.add_member(user2)
    end

    it 'should be able to add members' do
      request.env["HTTP_REFERER"] = arbor_reloaded_project_user_stories_path project
      put :add_member, project_id: project.id, member: user3.email

      project.reload
      expect(project.members).to include(user)
      expect(project.members).to include(user2)
      expect(project.members).to include(user3)
    end
  end

  describe 'PUT join project with current user team member' do
    let!(:team)    { create :team }
    let!(:project) { create :project, team: team }

    before :each do
      team.users << user
    end

    it 'should not be member of team project by default' do
      expect(user.projects).not_to include(project)
    end

    it 'should allow team members to join' do
      put :join_project, project_id: project.id

      user.reload
      expect(user.projects).to include(project)
    end
  end

  describe 'PUT join project with current user outsider' do
    let!(:team)    { create :team }
    let!(:project) { create :project, team: team }
    let!(:user2)   { create :user }

    before :each do
      sign_in user2
    end

    it 'should not allow outsiders to join' do
      put :join_project, project_id: project.id

      user2.reload
      expect(user2.projects).not_to include(project)
    end
  end

  describe 'PUT update order' do
    context 'in backlog' do
      it 'should reorder user stories' do
        story_1 = create :user_story, project: project, backlog_order: 1
        story_2 = create :user_story, project: project, backlog_order: 2
        story_3 = create :user_story, project: project, backlog_order: 3

        stories =  { '0' => { id: story_1.id, backlog_order: 2 },
                     '1' => { id: story_2.id, backlog_order: 3 },
                     '2' => { id: story_3.id, backlog_order: 1 } }

        put :order_stories, project_id: project.id, stories: stories

        expect(UserStory.find(story_1.id).backlog_order).to eq 2
        expect(UserStory.find(story_2.id).backlog_order).to eq 3
        expect(UserStory.find(story_3.id).backlog_order).to eq 1
      end
    end
  end

  describe 'PUT update' do
    it 'should send a success response with the projects url when json' do
      put :update, format: :json, id: project.id, project: {
          favorite: true
        }

      project.reload
      expect(project.favorite).to be_truthy

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(true)
      expect(hash_response['data']['return_url']).to eq(arbor_reloaded_projects_list_path)
    end
  end

  describe 'PUT create' do
    it 'should create a new project with a team' do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:create_event).and_return(true)

      post :create, format: :html, project: { name: 'My project',
          favorite: true, team: team.name }

      expect{ Project.count }.to become_eq 1

      project = Project.last
      expect(project.name).to eq('My project')
      expect(project.team).to eq(team)
      expect(project.owner).to eq(team.owner)
    end

    it 'should add the team owner as member' do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:create_event).and_return(true)

      post :create, format: :html, project: { name: 'My project',
          favorite: true, team: team.name }

      project = Project.last
      expect(project.owner).to eq(team.owner)
      expect(project.members).to include(team.owner)
    end

    it 'should create a new project without a team' do
      allow_any_instance_of(ArborReloaded::IntercomServices)
        .to receive(:create_event).and_return(true)

      post :create, format: :html, project: { name: 'My project',
          favorite: true }

      expect{ Project.count }.to become_eq 1

      project = Project.first
      expect(project.name).to eq('My project')
      expect(project.owner).to eq(user)
    end
  end

  it 'should redirect to back when html' do
    request.env['HTTP_REFERER'] = arbor_reloaded_project_canvases_path(project.id)
    put :update, format: :html, id: project.id, project: {
        name: 'NewName'
      }

    project.reload
    expect(project.name).to eq('NewName')
    expect(response).to be_redirect
  end

  describe 'list_projects' do
    let!(:project)  { create :project, owner: user, favorite: false }
    let!(:project2) { create :project, owner: user, favorite: false }
    render_views

    it 'returns the projects list partial with html format' do
      get :list_projects, format: :html
      expect(response.body).to have_content(project.name)
      expect(response.body).to have_content(project2.name)
    end

    it 'should send a success response and the projects with json format' do
      get :list_projects, format: :json

      hash_response = JSON.parse(response.body)
      expect(hash_response['success']).to eq(true)
      route_helper = Rails.application.routes.url_helpers(project)
      expected_result =
      [
        { 'label' => project2.name, 'value' => route_helper.arbor_reloaded_project_user_stories_path(project2) },
        { 'label' => project.name, 'value' => route_helper.arbor_reloaded_project_user_stories_path(project) }
      ]
      expect((hash_response['data']['projects'] - expected_result).blank?).to be_truthy
    end
  end
end
