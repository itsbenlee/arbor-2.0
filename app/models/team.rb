class Team < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :owner

  has_many :team_users, dependent: :destroy
  has_many :users, through: :team_users
  belongs_to :owner, class_name: User
  has_many :projects

  def owner_name
    owner.full_name
  end

  def owner_email
    owner.email
  end

  def not_member(user)
    !users.include?(user)
  end

  def members_string
    users_count = users.count
    users_count == 1 ? "#{users_count} member" : "#{users_count} members"
  end
end
