module ArborReloaded
  class TeamsController < ApplicationController
    layout 'application_reload'
    before_action :authenticate_user!
    before_action :load_team, only: [:members, :update]

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

    def update
      @team.update_attributes(team_params)
      add_new_members
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

    def member_emails
      params[:team].select do |id, email|
        email if id.starts_with?('member') && email != current_user.email
      end.values.reject(&:blank?).uniq
    end

    def add_new_members
      emails = []
      member_emails.each do |email|
        user = User.find_by(email: email)
        @team.users << user if user
      end
      redirect_to :back if @team.save
    end

    def load_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name)
    end
  end
end
