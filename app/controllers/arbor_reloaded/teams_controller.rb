module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!
    before_action :load_team, only: [:members, :add_member, :remove_member]

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
      @errors = []
      add_new_member(member_params[:member])
      if @team.save
        @teams = current_user.teams
      else
        @errors = @team.errors.full_messages
      end
    end

    def remove_member
      member = User.find(member_params[:member])
      @team.projects.each do |project|
        project.members.delete(member)
      end
      @team.users.delete(member)
      @team.save
    end

    def members
      render layout: false
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

    def add_new_member(email)
      user = User.find_by(email: email)
      if user
        team_users = @team.users
        team_users << user unless team_users.include? user
      else
        return_error(email)
      end
    end

    def return_error(email)
      if email.empty?
        @errors << t('reloaded.team.no_email')
      else
        @errors << t('reloaded.team.no_user')
      end
    end

    def load_team
      id = params[:id] || params[:team_id]
      @team = Team.find(id)
    end

    def member_params
      params.permit(:member)
    end

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
