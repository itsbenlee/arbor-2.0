module ArborReloaded
  class ProjectsController < ApplicationController
    layout false, only: :members
    before_action :load_project,
      only: %i(members show edit update destroy log add_member join_project
               export_backlog remove_member_from_project export_to_spreadhseet
               release_plan)

    rescue_from ActiveRecord::RecordNotFound do
      render 'errors/404', status: 404
    end

    def index
      scope = params[:project_order] || 'recent'
      @projects = @projects.send(scope)
      @new_project = Project.new
      render layout: 'application_reload'
    end

    def create
      selected_team_name = team_params[:team]
      @new_project = Project.new(project_params)
      @new_project.assign_team(selected_team_name, current_user)

      members = @new_project.members
      members << current_user unless members.include?(current_user)
      assist_creation
    end

    def list_projects
      respond_to do |format|
        format.html do
          render partial: 'arbor_reloaded/projects/partials/projects_list',
                 locals: { projects: @projects }
        end
        format.json do
          json_list
        end
      end
    end

    def show
      render layout: 'application_reload'
      @invites = Invite.where(project: @project)
      @can_delete = current_user.can_delete?(@project)
    end

    def members
      members = @project.members
      render 'arbor_reloaded/projects/members', locals: {
        project: @project,
        members: members,
        invites: Invite.where(project: @project),
        owner: members.find(@project.owner_id),
        can_delete: current_user.can_delete?(@project)
      }
    end

    def destroy
      @project.destroy
      redirect_to arbor_reloaded_projects_path
    end

    def join_project
      if current_user.teams.include?(@project.team)
        @project.add_member(current_user)
      end
      redirect_to arbor_reloaded_project_user_stories_path(@project)
    end

    def add_member
      member_param = params.permit(:member)
      ArborReloaded::ProjectMemberService.new(
        @project, current_user, member_param[:member]).invite_member
      if @project.save
        redirect_to :back
      else
        @errors = @project.errors.full_messages
        render :edit, status: 400
      end
    end

    def remove_member_from_project
      member_to_destroy = MembersProject.find_by(member_id: params['member'],
                                                 project_id: @project.id)
      member_to_destroy.destroy
      render partial: 'arbor_reloaded/navigation/right_members',
             locals: { project: @project.reload }
    end

    def update
      @project.update_attributes(project_params)
      respond_to do |format|
        format.json { json_update }
        format.html { html_update }
      end
    end

    def export_backlog
      parameters = params.permit(:estimation)
      @estimation = parameters[:estimation].blank?
      send_data(export_content,
                filename: "#{@project.name} Backlog.pdf",
                type:     'application/pdf')
      ArborReloaded::IntercomServices.new(current_user)
        .create_event(t('intercom_keys.pdf_export'))
    end

    def order_stories
      project = Project.includes(:user_stories, :groups)
                .find(params[:project_id])
      project_services = ArborReloaded::ProjectServices.new(project)
      project_ordered = project_services.reorder_stories(update_order_params)
      data = render_to_string(partial: 'arbor_reloaded/groups/list',
                              layout: false,
                              locals: { project: project_ordered,
                                        groups: project_ordered.groups })
      render json: { data: data }
    end

    def log
      @users = @project.members
      project_services = ArborReloaded::ProjectServices.new(@project)
      @activities = project_services.all_activities
      render layout: 'application_reload'
    end

    def copy
      project =
        current_user.projects
        .includes(user_stories: [:acceptance_criterions])
        .find(params[:project_id])

      project_services = ArborReloaded::ProjectServices.new(project)
      project_services.replicate(current_user)

      redirect_to :back
    end

    def export_to_spreadhseet
      send_data(SpreadsheetExporterService.export(@project),
                                                  disposition: 'inline')
    end

    def release_plan
      render layout: 'application_reload'
    end

    private

    def export_content
      project_name = @project.name
      project_team = @project.team
      team_name = project_team.name if project_team
      cover_html =
        render_to_string(partial: 'arbor_reloaded/projects/pdf_cover.html.haml',
                         layout: 'pdf_cover_reloaded.pdf.haml',
                         locals: { project_name: project_name,
                                   team_name: team_name })

      send(:render_to_string,
           pdf: project_name,
           layout: 'application_reloaded.pdf.haml',
           template: 'arbor_reloaded/projects/index.pdf.haml',
           cover: cover_html,
           margin: { top: 30, bottom: 30 })
    end

    def team_params
      params.require(:project).permit(:team)
    end

    def json_list
      response = ArborReloaded::ProjectServices.new(@project)
                 .projects_json_list(@projects)
      render json: response, status: (response.success ? 201 : 422)
    end

    def html_update
      @errors = @project.errors.full_messages unless @project.save
      redirect_to :back
    end

    def json_update
      response = ArborReloaded::ProjectServices.new(@project).update_project
      if project_params[:favorite] == 'true'
        ArborReloaded::IntercomServices.new(current_user)
          .create_event(t('intercom_keys.favorite_project'))
      end
      render json: response, status: (response.success ? 201 : 422)
    end

    def assist_creation
      if @new_project.save
        ArborReloaded::IntercomServices
          .new(current_user).create_event(t('intercom_keys.create_project'))
        @new_project.create_activity :create_project
        redirect_to arbor_reloaded_project_user_stories_path(@new_project)
      else
        render 'arbor_reloaded/projects/index', layout: 'application_reload'
      end
    end

    def project_params
      params.require(:project).permit(:name,
        :favorite, :velocity, :cost_per_week,
        :slack_token, :slack_channel_id)
    end

    def load_project
      id = params[:id] || params[:project_id]
      @project = Project.find(id)
      has_access = current_user.available_projects.include?(@project)
      fail ActiveRecord::RecordNotFound unless has_access
    end

    def update_order_params
      params.require(:stories)
    end
  end
end
