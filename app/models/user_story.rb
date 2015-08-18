class UserStory < ActiveRecord::Base
  PRIORITIES = %w(m s c w)

  validates_presence_of :role
  validates_presence_of :action
  validates_presence_of :result
  validates_presence_of :priority

  validates_inclusion_of :priority, in: PRIORITIES

  belongs_to :project

  def self.priorities
    PRIORITIES
  end

  def self.estimation_series
    fibonacci = ->(x){ x < 2 ? x : fibonacci[x-1] + fibonacci[x-2] }
    (2..12).map { |index| fibonacci[index] }
  end
end
