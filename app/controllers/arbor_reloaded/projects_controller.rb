module ArborReloaded
  class ProjectsController < ApplicationController
    layout false, only: :members
    before_action :load_project,
                  only: [:show, :edit, :update, :destroy,
                         :log, :export_to_spreadhseet]
    def index
      render layout: 'application_reload'
    end

    def new
      render layout: 'application_reload'
    end

    def edit
      render layout: 'application_reload'
    end

    def show
      render layout: 'application_reload'
      @invites = Invite.where(project: @project)
      @can_delete = current_user.can_delete?(@project)
    end

    def members
      @project = Project.find(params[:project_id])
      @members = @project.members
      @owner = @members.find(@project.owner_id)
      @invites = Invite.where(project: @project)
      @can_delete = current_user.can_delete?(@project)
      render 'arbor_reloaded/projects/members', locals: {
        project: @project,
        members: @members,
        invites: @invites,
        owner: @owner,
        can_delete: @can_delete
      }
    end

    def destroy
      @project.destroy
      redirect_to projects_path
    end

    def remove_member_from_project
      project_id = params['project_id']
      member_to_destroy = MembersProject.find_by(member_id: params['member'],
                                                 project_id: project_id)

      if member_to_destroy.destroy
        render json: { errors: [] }, status: 200
      else
        @errors = member_to_destroy.errors.full_messages
        render json: { errors: @errors }, status: 422
      end
    end

    def update
      @project.update_attributes(name: project_params[:name])
      assign_associations

      if @project.save
        redirect_to project_path @project
      else
        @errors = @project.errors.full_messages
        render :edit, status: 400
      end
    end

    def create
      @project = Project.new(project_params)
      @project.owner = current_user
      assist_creation
    end

    def order_stories
      project = Project.includes(:user_stories).find(params[:project_id])
      project_services = ProjectServices.new(project)
      render json: project_services.reorder_stories(update_order_params)
    end

    def log
      project_services = ProjectServices.new(@project)
      @activities_by_pages = project_services.activities_by_pages
    end

    def backlog
      project = Project.includes(
        user_stories: [:acceptance_criterions, :constraints],
        members: {},
        hypotheses: {})
                .order('user_stories.backlog_order')
                .find(params[:project_id])
      user_stories = project.user_stories

      render partial: 'user_stories/backlog_list',
             locals:
             {
               user_stories: user_stories,
               project: project,
               total_points: UserStory.total_points(user_stories)
             }
    end

    def copy
      project =
        Project
        .includes(user_stories: [:acceptance_criterions, :constraints],
                  hypotheses: [:user_stories, :goals])
        .find(params[:project_id])

      project_services = ProjectServices.new(project)
      project_services.replicate(current_user)

      redirect_to :back
    end

    def export_to_spreadhseet
      send_data(
        SpreadsheetExporterService.export(@project), disposition: 'inline')
    end

    private

    def assist_creation
      if @project.save
        @project.create_activity :create_project
        assign_associations
        redirect_to arbor_reloaded_project_canvases_path(@project)
      else
        @errors = @project.errors.full_messages
        render :new, status: 400
      end
    end

    def project_params
      params.require(:project).permit(:name)
    end

    def load_project
      @project = Project.find(params[:id])
    end

    def member_emails
      params[:project].select do |id, email|
        email if id.starts_with?('member') && email != current_user.email
      end.values.reject(&:blank?).uniq
    end

    def assign_associations
      @project.owner ||= current_user
      ProjectMemberServices.new(
        @project, current_user, member_emails
      ).invite_members
    end

    def update_order_params
      params.require(:stories)
    end
  end
end
