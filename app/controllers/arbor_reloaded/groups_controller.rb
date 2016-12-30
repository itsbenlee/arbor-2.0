module ArborReloaded
  class GroupsController < ApplicationController
    before_action :set_project_and_groups, only: %i(index create)
    before_action :set_group, except: %i(index create)

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

    def up
      @group.up
      head :ok
    end

    def down
      @group.down
      head :ok
    end

    def active
      @group.active!
      head :ok
    end

    def inactive
      @group.inactive!
      head :ok
    end

    private

    def group_params
      params.require(:group).permit(:name, :order, :preset_order)
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

    def json_status
      render_to_string(partial: '',
                       layout: false,
                       locals: {})
    end
  end
end
