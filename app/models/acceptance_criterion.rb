class AcceptanceCriterion < ActiveRecord::Base
  belongs_to :user_story
  validates_presence_of :description
  validates_uniqueness_of :description, scope: :user_story_id
end
