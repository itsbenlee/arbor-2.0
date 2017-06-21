class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :sprint_user_stories, dependent: :destroy
  has_many :user_stories, through: :sprint_user_stories

  validates_presence_of :project

  def as_json(*_args)
    {
      id: id,
      user_stories: user_stories.map(&:as_json),
      total_points: user_stories.sum(:estimated_points)
    }
  end
end
