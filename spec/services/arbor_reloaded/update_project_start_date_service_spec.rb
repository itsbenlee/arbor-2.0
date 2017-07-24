require 'spec_helper'

describe ArborReloaded::UpdateProjectStartDateService do
  let(:user)    { create :user }
  let(:project) { create :project, owner: user }
  let(:update_project_start_date_service) do
    ArborReloaded::UpdateProjectStartDateService.new(project.id, user)
  end

  describe '.new' do
    describe 'user is not project member' do
      it 'should raise an ActiveRecord::RecordNotFound error user is not a project member' do
        expect {
          ArborReloaded::UpdateProjectStartDateService.new(project.id, create(:user))
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    describe 'user is not the project owner' do
      let(:member_user) do
        member = create(:user)
        project.members << member

        member
      end

      it 'should not raise any kind of error' do
        expect {
          ArborReloaded::UpdateProjectStartDateService.new(project.id, member_user)
        }.not_to raise_error
      end
    end
  end

  describe '#starting_date' do
    it 'should update project starting date attribute' do
      expect {
        update_project_start_date_service.starting_date(Date.tomorrow)
      }.to change { project.reload.starting_date }.to(Date.tomorrow)
    end
  end

  describe '#release_plan' do
    subject { update_project_start_date_service.release_plan }

    it { should eq project.to_release_plan }
  end
end
