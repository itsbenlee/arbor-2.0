module ArborReloaded
  class GroupsController < ApplicationController
    before_action :set_project_and_groups, except: [:destroy, :update]
    before_action :set_group, only: [:destroy, :update]

    def index
      render partial: 'arbor_reloaded/groups/list',
             locals: { groups: @groups, project: @project }
    end

    def create
      @group = @groups.create(group_params)
      @errors = @group.errors.full_messages
      @group.add_ungrouped_stories if @errors.empty? && add_ungrouped_stories?
    end

    def update
      @group.update(group_params)
      @project = @group.project
      @groups = @project.groups
      @errors = @group.try(:errors).try(:full_messages)
    end

    def destroy
      @group.destroy
      redirect_to :back
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end

    def set_project_and_groups
      @project = Project.find(params[:project_id])
      @groups = @project.groups
    end

    def set_group
      @group = Group.includes(:user_stories).find(params[:id])
    end

    def add_ungrouped_stories?
      params[:add_ungrouped_stories] == 'true'
    end
  end
end
