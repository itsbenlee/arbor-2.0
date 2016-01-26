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
      @team = Team.create(name: team_params[:name], owner: current_user)
      @team.users << current_user
    end

    private

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
