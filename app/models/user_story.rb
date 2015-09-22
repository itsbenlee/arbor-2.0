class UserStory < ActiveRecord::Base
  PRIORITIES = %w(must should could would)

  validates_presence_of :role, :action, :result
  validates_uniqueness_of :order, scope: :hypothesis_id, allow_nil: true
  validates_uniqueness_of :backlog_order, scope: :project_id, allow_nil: true
  validates_uniqueness_of :story_number, scope: :project_id
  validates_inclusion_of :priority, in: PRIORITIES
  before_create :order_in_hypotheses, :order_in_backlog, :assign_story_number
  after_create :update_next_story_number

  has_many :acceptance_criterions, dependent: :destroy
  has_many :constraints, dependent: :destroy
  belongs_to :hypothesis
  belongs_to :project

  include AssociationLoggable

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? arg : fib[arg - 1] + fib[arg - 2] }
    (2..12).map { |index| fib[index] }.unshift([nil])
  end

  def log_description
    "#{I18n.t('backlog.user_stories.role')} "\
      "#{role} "\
      "#{I18n.t('backlog.user_stories.action', priority: priority)} "\
      "#{action} "\
      "#{I18n.t('backlog.user_stories.result')} "\
      "#{result}"
  end

  def recipient
    project
  end

  private

  def order_in_hypotheses
    return unless hypothesis
    self.order = hypothesis.user_stories.maximum(:order).to_i + 1
  end

  def assign_story_number
    self.story_number = project.next_story_number
  end

  def order_in_backlog
    self.backlog_order = project.user_stories.maximum(:backlog_order).to_i + 1
  end

  def update_next_story_number
    project.update_attribute :next_story_number, project.next_story_number + 1
  end
end
