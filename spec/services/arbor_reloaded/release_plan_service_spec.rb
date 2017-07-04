describe ArborReloaded::ReleasePlanService do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user }
  let(:sprint)  { project.sprints.first }

  describe '.new' do
    describe 'fake project id' do
      it 'should raise an ActiveRecord::RecordNotFound error' do
        expect{
          ArborReloaded::ReleasePlanService.new(0, user)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'not owned project' do
      let(:other_project) { create :project }

      it 'should raise an ActiveRecord::RecordNotFound error' do
        expect{
          ArborReloaded::ReleasePlanService.new(other_project.id, user)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'project that user owns' do

      it 'should not raise any kind of error' do
        expect{
          ArborReloaded::ReleasePlanService.new(project.id, user)
        }.not_to raise_error
      end
    end
  end

  describe '.plan' do
    let!(:user_story) { create(:sprint_user_story, sprint: sprint).user_story }

    describe 'project data' do
      subject { ArborReloaded::ReleasePlanService.new(project.id, user).plan }

      it { should include(name: project.name) }
      it { should include(sprints: project.reload.sprints.map(&:as_json)) }
    end

    describe 'sprints data' do
      subject do
        ArborReloaded::ReleasePlanService.new(project.id, user).plan[:sprints]
      end

      it { should include sprint.as_json }
    end

    describe 'user stories data' do
      let(:sprints_array) { ArborReloaded::ReleasePlanService.new(project.id, user).plan[:sprints] }

      it 'should add user story to the right sprint' do
        sprints_array.each do |sprint_hash|
          next unless sprint_hash[:id] == sprint.id

          expect(sprint_hash[:user_stories]).to include user_story.as_json
        end
      end
    end
  end

  describe '.add_sprint' do
    let(:release_plan_service) { ArborReloaded::ReleasePlanService.new(project.id, user) }

    it 'should add a new sprint to project' do
      expect {
        release_plan_service.add_sprint
      }.to change { project.sprints.reload.count }.from(5).to(6)
    end

    describe 'response data' do
      subject { release_plan_service.add_sprint }

      it { should have_key :name }
      it { should have_key :sprints }
    end
  end

  describe '.delete_sprint' do
    let(:release_plan_service) { ArborReloaded::ReleasePlanService.new(project.id, user) }

    describe "sprint doesn't belongs to project" do
      let(:other_sprint) { create :sprint }

      it 'should raise an ActiveRecord::RecordNotFound error' do
        expect{
          release_plan_service.delete_sprint(other_sprint.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'sprint belongs to project' do
      it 'should remove the selected sprint from project' do
        expect {
          release_plan_service.delete_sprint(sprint.id)
        }.to change { project.sprints.reload.count }.from(5).to(4)
      end

      describe 'response data' do
        subject { release_plan_service.delete_sprint(sprint.id) }

        it { should have_key :name }
        it { should have_key :sprints }
      end
    end
  end
end
