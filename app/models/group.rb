class Group < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name, scope: :project_id
  belongs_to :project
  has_many :user_stories
end
