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
end
