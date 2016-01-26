class Team < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  has_many :team_users
  has_many :users, through: :team_users

  scope :my_teams, lambda { |user|
    where('manager_id = ?', user.id)
  }
end
