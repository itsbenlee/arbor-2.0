class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :sprint_user_stories, dependent: :destroy
  has_many :user_stories, through: :sprint_user_stories
end
