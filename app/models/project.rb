class Project < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :owner, class_name: User
  has_many :members_projects, class: MembersProject
  has_many :members, class_name: User, through: :members_projects
end
