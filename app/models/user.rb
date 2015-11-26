class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :full_name
  validates_presence_of :email
  validates_uniqueness_of :email

  has_many :members_projects,
           foreign_key: :member_id,
           class_name: MembersProject
  has_many :projects, through: :members_projects
  has_many :owned_projects, foreign_key: :owner_id, class_name: Project
  has_many :attachments

  def can_delete?(project)
    self == project.owner
  end

  def log_description
    full_name
  end
end
