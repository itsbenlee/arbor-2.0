class UserStory < ActiveRecord::Base
  include PublicActivity::Common

  acts_as_commentable

  validates_uniqueness_of :backlog_order, scope: :project_id, allow_nil: true
  validates_uniqueness_of :story_number, scope: :project_id
  before_create :order_in_backlog, :assign_story_number
  after_create :update_next_story_number

  has_many :acceptance_criterions,
    -> { order(order: :asc) }, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :project
  belongs_to :group

  scope :backlog_ordered, -> { order(backlog_order: :desc) }

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? arg : fib[arg - 1] + fib[arg - 2] }
    (2..8).map { |index| fib[index] }.unshift([nil]).flatten
  end

  def log_description
    return description unless role
    "As #{role.with_indefinite_article} "\
    "#{I18n.t('reloaded.backlog.action')} "\
    "#{action} "\
    "#{I18n.t('reloaded.backlog.result')} "\
    "#{result}"
  end

  def points_for_trello
    estimated_points.present? ? estimated_points : '*'
  end

  def copy_in_project(new_id)
    replica = UserStory.create(role: role,
                               action: action,
                               result: result,
                               project_id: new_id,
                               estimated_points: estimated_points,
                               priority: priority)

    copy_associations(replica.id)
  end

  def as_json(*_args)
    { id: id,
      description: description,
      role: role,
      action: action,
      result: result,
      estimated_points: estimated_points,
      acceptance_criterions: acceptance_criterions.map(&:as_json) }.compact
  end

  def self.from_hash(hash, project)
    filters = { role: hash['role'],
                result: hash['result'],
                action: hash['action'] }

    project.user_stories.where(filters).first_or_create
  end

  private

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
    copy_comments(replica_id)
  end

  def copy_comments(replica_id)
    comments.each do |comment|
      comment.copy_comment(replica_id)
    end
  end

  def copy_criterions(replica_id)
    acceptance_criterions.each do |criterion|
      criterion_replica =
      AcceptanceCriterion.new(description: criterion.description,
                              user_story_id: replica_id)
      criterion_replica.save
    end
  end

  with_options unless: :role_action_or_result_missing? do |user_story|
    user_story.validates :role, :action, :result, presence: true
  end

  with_options if: :role_action_or_result_missing? do |user_story|
    user_story.validates :description, presence: true
  end

  def role_action_or_result_missing?
    role.blank? || action.blank? || result.blank?
  end
end
