class Team < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :owner

  has_many :team_users
  has_many :users, through: :team_users
  belongs_to :owner, class_name: User
  has_many :projects

  def owner_name
    owner.full_name
  end

  def owner_email
    owner.email
  end
end
