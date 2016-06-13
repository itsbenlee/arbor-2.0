class Invite < ActiveRecord::Base
  validates_presence_of :email
  validates_uniqueness_of :email, scope: %i(project_id team_id)
  after_create :send_email

  belongs_to :project
  belongs_to :team

  scope :for_projects, lambda { |email|
    where(email: email).where.not(project: nil)
  }

  scope :for_teams, lambda { |email|
    where(email: email).where.not(team: nil)
  }

  def log_description
    email
  end

  private

  def send_email
    return unless team_id
    TeamInviteMailer.team_invite_email(team_name: team.name,
                                       email: email).deliver_now
  end
end
