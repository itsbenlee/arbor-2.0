class Invite < ActiveRecord::Base
  validates_presence_of :email
  validates_presence_of :project

  belongs_to :project
end
