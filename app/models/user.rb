include Gravtastic
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  gravtastic default: 'blank', size: 150

  validates_presence_of :full_name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_uniqueness_of :slack_id, allow_nil: true

  has_many :members_projects,
           foreign_key: :member_id,
           class_name: MembersProject
  has_many :projects, through: :members_projects
  has_many :owned_projects, foreign_key: :owner_id, class_name: Project
  has_many :owned_teams, foreign_key: :owner_id, class_name: Team
  has_many :attachments
  has_many :comments
  has_many :team_users
  has_many :teams, through: :team_users

  mount_uploader :avatar, UserAvatarImageUploader

  def can_delete?(project)
    self == project.owner
  end

  def log_description
    full_name
  end
end
