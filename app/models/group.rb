class Group < ActiveRecord::Base
  belongs_to :project
  has_many :user_stories

  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id
end
