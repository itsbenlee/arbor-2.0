class UserStory < ActiveRecord::Base
  PRIORITIES = %w(m s c w)

  validates_presence_of :role, :action, :result
  validates_uniqueness_of :order, scope: :hypothesis_id
  validates_inclusion_of :priority, in: PRIORITIES
  before_create :order_in_hypotheses

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
    self.order = hypothesis.user_stories.maximum(:order).to_i + 1
  end
end
