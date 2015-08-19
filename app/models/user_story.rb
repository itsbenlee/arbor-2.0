class UserStory < ActiveRecord::Base
  PRIORITIES = %w(m s c w)

  validates_presence_of :role
  validates_presence_of :action
  validates_presence_of :result

  validates_inclusion_of :priority, in: PRIORITIES

  belongs_to :hypothesis
  belongs_to :project

  def self.priorities
    PRIORITIES
  end

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? x : fib[arg - 1] + fib[arg - 2] }
    (2..12).map { |index| fib[index] }
  end
end
