module ArborReloaded
  class GroupsController < ApplicationController
    before_action :set_project_and_groups

    def index
      render partial: 'arbor_reloaded/groups/list',
             locals: { groups: @groups, project: @project }
    end

    def create
      @groups.create(group_params)
      @errors = @groups.try(:last).try(:errors).try(:full_messages)
    end

    private

    def group_params
      params.require(:group).permit(:name)
    end

    def set_project_and_groups
      @project = Project.find(params[:project_id])
      @groups = @project.groups
    end
  end
end
