class Constraint < ActiveRecord::Base
  include WithoutAssociationLoggable

  validates_presence_of :description
  validates_uniqueness_of :description, scope: :user_story_id

  belongs_to :user_story

  def log_description
    description
  end

  def recipient
    user_story
  end
end
