module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

    def new
      render layout: 'application_reload'
    end

    def index
      @new_team = Team.new
      @teams = current_user.teams
    end

    def create
      team = Team.new(name: team_params[:name], owner: current_user)
      team.users.push(current_user)
      if team.save
        @teams = current_user.teams
      else
        @errors = team.errors.full_messages
      end
    end

    private

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
