describe ArborReloaded::SprintUserStoryService do
  let(:user)       { create :user }
  let!(:project)   { create :project, owner: user }
  let(:user_story) { create :user_story, project: project }
  let(:sprint)     { create :sprint, project: project }

  describe '.new' do
    describe "project doesn't belongs to user" do
      let(:other_project) { create :project }

      it 'should return an ActiveRecord::RecordNotFound error' do
        expect {
          ArborReloaded::SprintUserStoryService.new(user, other_project.id, sprint.id, user_story.id)
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "user story doesn't belongs to project" do
      let(:other_user_story) { create :user_story }

      it 'should return an ActiveRecord::RecordNotFound error' do
        expect {
          ArborReloaded::SprintUserStoryService.new(user, project.id, sprint.id, other_user_story.id)
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe "sprint doesn't belongs to project" do
      let(:other_sprint) { create :sprint }

      it 'should return an ActiveRecord::RecordNotFound error' do
        expect {
          ArborReloaded::SprintUserStoryService.new(user, project.id, other_sprint.id, user_story.id)
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'user story, sprint, project belongs to user' do
      it 'should not raise error' do
        expect {
          ArborReloaded::SprintUserStoryService.new(user, project.id, sprint.id, user_story.id)
        }.not_to raise_error
      end
    end
  end

  describe '.delete_user_story' do
    let(:sprint_user_story_service) do
      ArborReloaded::SprintUserStoryService.new(
        user,
        project.id,
        sprint.id,
        user_story.id
      )
    end

    describe "user story doesn't belongs to sprint" do
      it 'should return an ActiveRecord::RecordNotFound error' do
        expect { sprint_user_story_service.delete_user_story }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'user story is removed from sprint' do
      let!(:sprint_user_story) { create :sprint_user_story, user_story: user_story, sprint: sprint }

      it 'removes the story' do
        expect {
          sprint_user_story_service.delete_user_story
        }.to change { sprint.user_stories.count }.from(1).to(0)
      end
    end
  end
end
