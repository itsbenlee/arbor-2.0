class UserStory < ActiveRecord::Base
  include WithoutAssociationLoggable

  PRIORITIES = %w(m s c w)

  validates_presence_of :role, :action, :result
  validates_uniqueness_of :order, scope: :hypothesis_id, allow_nil: true
  validates_uniqueness_of :story_number, scope: :project_id
  validates_inclusion_of :priority, in: PRIORITIES
  before_create :order_in_hypotheses
  before_create :assign_story_number

  belongs_to :hypothesis
  belongs_to :project

  def self.priorities
    PRIORITIES
  end

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? x : fib[arg - 1] + fib[arg - 2] }
    (2..12).map { |index| fib[index] }
  end

  private

  def order_in_hypotheses
    return unless hypothesis
    self.order = hypothesis.user_stories.maximum(:order).to_i + 1
  end

  def assign_story_number
    self.story_number = project.user_stories.maximum(:story_number).to_i + 1
  end
end
