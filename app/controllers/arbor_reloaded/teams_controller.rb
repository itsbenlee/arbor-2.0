module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!

    def new
      render layout: 'application_reload'

    def index
      @teams = current_user.teams
    end

    def show
      @new_team = Team.new
      @team = Team.find(params[:id])
    end

    def index
    end

    def create
      @new_team = Team.new(name: team_params[:name],
                           manager_id: current_user.id)
      assist_creation
    end

    private

    def team_params
      params.require(:team).permit(:name)
    end

    def assist_creation
      if @new_team.save
        redirect_to arbor_reloaded_team_path(@new_team)
      else
        render 'arbor_reloaded/teams/index', layout: 'application_reload'
      end
    end
  end
end
