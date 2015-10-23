class Tag < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id
  has_and_belongs_to_many :user_stories
  belongs_to :project

  def log_description
    name
  end
end
