module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!
    before_action :load_team, only: %i(members add_member remove_member)
    before_action :find_member, only: :add_member

    def index
      @new_team = Team.new
      @teams = current_user.teams
    end

    def create
      if current_user.teams.map(&:name).include?(team_params[:name])
        @errors = [t('reloaded.team.name_uniqueness')]
      else
        create_team
      end
    end

    def add_member
      if @member
        @team.users << @member
      else
        Invite.create(email: member_params.try(:squish), team: @team)
      end

      @teams = current_user.teams
    end

    def remove_member
      member = User.find(member_params)
      @team.projects.each { |project| project.members.delete(member) }
      @team.users.delete(member)
      @team.save
    end

    def members
      render layout: false
    end

    def destroy
      team = current_user.teams.find(params[:id])
      team.projects.each { |project| project.update_attributes(team: nil) }

      unless team.destroy
        flash[:alert] = I18n.t('reloaded.team.can_not_delete_team')
      end
      redirect_to :back
    end

    private

    def create_team
      team = Team.new(name: team_params[:name], owner: current_user)
      team.users.push(current_user)
      if team.save
        @teams = current_user.reload.teams
      else
        @errors = team.errors.full_messages
      end
    end

    def load_team
      id = params[:id] || params[:team_id]
      @team = Team.find(id)
    end

    def member_params
      params.require(:member)
    end

    def team_params
      params.require(:team).permit(:name)
    end

    def find_member
      @member = User.find_by_email(member_params)
    end
  end
end
