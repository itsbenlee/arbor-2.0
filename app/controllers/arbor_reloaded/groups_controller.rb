module ArborReloaded
  class GroupsController < ApplicationController
    before_action :set_project_and_groups, except: :destroy
    before_action :set_group, only: :destroy

    def index
      render partial: 'arbor_reloaded/groups/list',
             locals: { groups: @groups, project: @project }
    end

    def create
      @groups.create(group_params)
      @errors = @groups.try(:last).try(:errors).try(:full_messages)
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
  end
end
