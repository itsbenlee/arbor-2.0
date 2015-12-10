class UserStory < ActiveRecord::Base
  PRIORITIES = %w(must should could would)
  acts_as_commentable

  validates_presence_of :role, :action, :result
  validates_uniqueness_of :order, scope: :hypothesis_id, allow_nil: true
  validates_uniqueness_of :backlog_order, scope: :project_id, allow_nil: true
  validates_uniqueness_of :story_number, scope: :project_id
  validates_inclusion_of :priority, in: PRIORITIES
  before_create :order_in_hypotheses, :order_in_backlog, :assign_story_number
  before_save :assign_hypothesis
  after_create :update_next_story_number

  has_and_belongs_to_many :tags
  has_many :acceptance_criterions,
    -> { order(order: :asc) }, dependent: :destroy
  has_many :comments
  has_many :constraints,
    -> { order(order: :asc) }, dependent: :destroy
  belongs_to :hypothesis
  belongs_to :project

  scope :ordered, -> { order(order: :asc) }
  scope :not_archived, -> { where(archived: false) }
  scope :archived, -> { where(archived: true) }

  include AssociationLoggable

  def self.total_points(user_stories)
    user_stories.map(&:estimated_points).compact.sum
  end

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? arg : fib[arg - 1] + fib[arg - 2] }
    (2..8).map { |index| fib[index] }.unshift([nil]).flatten
  end

  def log_description
    "As #{role.indefinite_article} "\
    "#{role} "\
    "#{I18n.t('backlog.user_stories.action', priority: priority)} "\
    "#{action} "\
    "#{I18n.t('backlog.user_stories.result')} "\
    "#{result}"
  end

  def recipient
    project
  end

  def points_for_trello
    estimated_points.present? ? estimated_points : '*'
  end

  def copy_in_project(new_id, new_hypothesis_id)
    replica =
      UserStory.new(role: role,
                    action: action,
                    result: result,
                    project_id: new_id,
                    hypothesis_id: new_hypothesis_id,
                    estimated_points: estimated_points,
                    priority: priority)
    replica.save
    copy_associations(replica.id)
  end

  def clean_log
    activities.delete_all
    [clean_criterions_log, clean_constraints_log].each(&:join)
  end

  def reorder_criterions(criterions_hash)
    acceptance_criterions.update_all order: nil
    criterions_hash.values.each do |criterion|
      acceptance_criterions
        .find(criterion['id'].to_i)
        .update_attributes!(order: criterion['criterion_order'].to_i)
    end
  end

  def reorder_constraints(constraints_hash)
    constraints.update_all order: nil
    constraints_hash.values.each do |constraint|
      constraints
        .find(constraint['id'].to_i)
        .update_attributes!(order: constraint['constraint_order'].to_i)
    end
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

  def copy_associations(replica_id)
    copy_criterions(replica_id)
    copy_constraints(replica_id)
  end

  def copy_criterions(replica_id)
    acceptance_criterions.each do |criterion|
      criterion_replica =
      AcceptanceCriterion.new(description: criterion.description,
                              user_story_id: replica_id)
      criterion_replica.save
    end
  end

  def copy_constraints(replica_id)
    constraints.each do |constraint|
      constraint_replica =
      Constraint.new(description: constraint.description,
                     user_story_id: replica_id)
      constraint_replica.save
    end
  end

  def clean_criterions_log
    Thread.new { acceptance_criterions.each(&:clean_log) }
  end

  def clean_constraints_log
    Thread.new { constraints.each(&:clean_log) }
  end

  def assign_hypothesis
    self.hypothesis_id ||= project.undefined_hypothesis.id
  end
end
