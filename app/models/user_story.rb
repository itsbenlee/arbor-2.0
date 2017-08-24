class UserStory < ActiveRecord::Base
  include PublicActivity::Common

  acts_as_commentable
  acts_as_list column: :backlog_order, top_of_list: 1, add_new_at: :top,
               scope: :project

  validates_uniqueness_of :backlog_order, scope: :project_id, allow_nil: true
  validates_uniqueness_of :story_number,
                          scope: :project_id,
                          if: -> { story_number_changed? }

  validates_numericality_of :color,
                            only_integer: true,
                            allow_nil: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 7

  before_create :assign_story_number, unless: -> { story_number }
  after_create :update_next_story_number

  has_many :acceptance_criterions,
    -> { order(order: :asc) }, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sprint_user_stories, dependent: :destroy
  has_many :sprints, through: :sprint_user_stories

  belongs_to :project
  belongs_to :group

  scope :backlog_ordered, -> { order(backlog_order: :desc) }
  scope :ungrouped, -> { where(group_id: nil) }

  def self.estimation_series
    fib = ->(arg) { arg < 2 ? arg : fib[arg - 1] + fib[arg - 2] }
    (2..8).map { |index| fib[index] }.unshift(nil)
  end

  def log_description
    return description unless role

    I18n.t('reloaded.backlog.log', role: role.with_indefinite_article,
                                   action: action, result: result)
  end

  def points_for_trello
    estimated_points.present? ? estimated_points : '*'
  end

  def copy_in_project(new_project)
    replica = find_or_initialize_replica(new_project)

    replica.story_number = story_number
    replica.color = color
    replica.save

    copy_associations(replica) if replica.persisted?
  end

  def copy_out_project(new_project)
    replica = find_or_initialize_replica(new_project)

    replica.color = color
    replica.save

    copy_associations(replica) if replica.persisted?
  end

  def as_json(*_args)
    { id: id,
      description: description,
      role: role,
      action: action,
      result: result,
      estimated_points: estimated_points,
      color: color,
      acceptance_criterions: acceptance_criterions.map(&:as_json),
      group: group,
      done: done? }.compact
  end

  def as_summarized_json
    {
      id: id,
      description: description,
      role: role,
      action: action,
      result: result,
      estimated_points: estimated_points
    }.compact
  end

  def self.from_hash(hash, project)
    filters = { role: hash['role'],
                result: hash['result'],
                action: hash['action'] }

    project.user_stories.where(filters).first_or_create
  end

  def done?
    sprint_user_stories.where(status: 'DONE').any?
  end

  private

  def assign_story_number
    self.story_number = project.next_story_number
  end

  def update_next_story_number
    project.update_attribute :next_story_number, project.next_story_number + 1
  end

  def find_or_initialize_replica(new_project)
    new_project
      .user_stories
      .find_or_initialize_by(role: role,
                             action: action,
                             result: result,
                             description: description,
                             estimated_points: estimated_points,
                             priority: priority)
  end

  def copy_associations(replica)
    copy_criterions(replica)
    copy_comments(replica)
    copy_group(replica)
  end

  def copy_comments(replica)
    comments.each do |comment|
      replica.comments.create(comment.as_json)
    end
  end

  def copy_criterions(replica)
    acceptance_criterions.each do |criterion|
      replica.acceptance_criterions.create(description: criterion.description)
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

  def copy_group(replica)
    replica_group = replica.project.groups.find_by_name(group.try(:name))
    replica.update_attribute(:group_id, replica_group.try(:id))
  end
end
