require 'spec_helper'

RSpec.describe ArchivesController do
  describe 'GET index' do
    let!(:user)        { create :user }
    let!(:project)     { create :project, owner: user }
    let!(:user_story)  { create :user_story, project: project, archived: true }
    let!(:user_story2) { create :user_story, project: project, role: 'visitor' }

    before :each do
      sign_in user
    end

    describe 'GET list archived' do
      render_views

      it 'should return the remaining archived stories' do
        get(
          :list_archived,
          project_id: project.id,
        )
        expect(response.body).to have_text(user_story.log_description)
        expect(response.body).not_to have_text(user_story2.log_description)
      end
    end

    describe 'GET index' do
      render_views

      it 'should return the archived stories' do
        get(
          :index,
          project_id: project.id,
        )
        expect(response.body).to have_text(user_story.log_description)
        expect(response.body).not_to have_text(user_story2.log_description)
      end
    end
  end
end
