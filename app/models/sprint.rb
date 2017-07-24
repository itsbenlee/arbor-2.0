class Sprint < ActiveRecord::Base
  belongs_to :project
  has_many :sprint_user_stories, dependent: :destroy
  has_many :user_stories, through: :sprint_user_stories

  acts_as_list column: :position, top_of_list: 1, add_new_at: :bottom,
               scope: :project

  validates_presence_of :project

  delegate :starting_date, to: :project, prefix: true

  def as_json(*_args)
    {
      id: id,
      user_stories: user_stories.map(&:as_json),
      total_points: user_stories.sum(:estimated_points),
      delivery_date: (project_starting_date + position.to_i.weeks)
    }
  end
end
