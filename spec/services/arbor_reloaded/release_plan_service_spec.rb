describe ArborReloaded::ReleasePlanService do
  let(:user) { create :user }

  describe '.new' do
    describe 'fake project id' do
      it 'should raise an ActiveRecord::RecordNotFound error' do
        expect{
          ArborReloaded::ReleasePlanService.new(0, user)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'not owned project' do
      let(:project) { create :project }

      it 'should raise an ActiveRecord::RecordNotFound error' do
        expect{
          ArborReloaded::ReleasePlanService.new(project.id, user)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'project that user owns' do
      let(:project) { create :project, owner: user }

      it 'should not raise any kind of error' do
        expect{
          ArborReloaded::ReleasePlanService.new(project.id, user)
        }.not_to raise_error
      end
    end
  end

  describe '.plan' do
    let(:project)     { create :project, owner: user }
    let!(:sprint)     { create :sprint, project: project }
    let!(:user_story) { create(:sprint_user_story, sprint: sprint).user_story }

    describe 'project data' do
      subject { ArborReloaded::ReleasePlanService.new(project.id, user).plan }

      it { should include(name: project.name) }
      it { should include(sprints: project.reload.sprints.map(&:as_json)) }
    end

    describe 'sprints data' do
      subject do
        ArborReloaded::ReleasePlanService.new(project.id, user)
                                         .plan[:sprints][0]
      end

      it { should eq sprint.as_json }
    end

    describe 'user stories data' do
      subject do
        ArborReloaded::ReleasePlanService.new(project.id, user)
                                         .plan[:sprints][0][:user_stories][0]
      end

      it { should eq user_story.as_json }
    end
  end

  describe '.add_sprint' do
    let(:project)              { create :project, owner: user }
    let(:release_plan_service) { ArborReloaded::ReleasePlanService.new(project.id, user) }

    it 'should add a new sprint to project' do
      expect {
        release_plan_service.add_sprint
      }.to change { project.sprints.reload.count }.from(0).to(1)
    end

    describe 'response data' do
      subject { release_plan_service.add_sprint }

      it { should have_key :name }
      it { should have_key :sprints }
    end
  end

  describe '.delete_sprint' do
    let(:project)              { create :project, owner: user }
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
      let!(:sprint) { create :sprint, project: project }

      it 'should remove the selected sprint from project' do
        expect {
          release_plan_service.delete_sprint(sprint.id)
        }.to change { project.sprints.reload.count }.from(1).to(0)
      end

      describe 'response data' do
        subject { release_plan_service.delete_sprint(sprint.id) }

        it { should have_key :name }
        it { should have_key :sprints }
      end
    end
  end
end
