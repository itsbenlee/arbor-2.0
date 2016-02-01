module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

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

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
