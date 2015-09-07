class Invite < ActiveRecord::Base
  validates_presence_of :email, :project
  validates_uniqueness_of :email, scope: :project_id

  belongs_to :project

  def log_description
    email
  end
end
