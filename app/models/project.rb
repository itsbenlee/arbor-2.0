class Project < ActiveRecord::Base
  include PublicActivity::Common

  DEFAULT_SPRINTS_AMOUNT = ENV.fetch('DEFAULT_SPRINTS_AMOUNT', 5).to_i

  validates_presence_of :name
  validates_uniqueness_of :name,
                          scope: :owner,
                          message: 'Project name already exists'
  validates_uniqueness_of :slack_channel_id, allow_nil: true
  validates_uniqueness_of :slack_iw_url, allow_nil: true
  validates_uniqueness_of :is_template,
    if: proc { |project| project.is_template }
  validates_numericality_of :velocity,
                            greater_than_or_equal_to: 0,
                            allow_nil: true

  belongs_to :owner, class_name: User
  belongs_to :team
  has_one :canvas, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :user_stories, dependent: :destroy
  has_many :members_projects, class_name: MembersProject
  has_many :members, class_name: User, through: :members_projects
  has_many :groups
  has_many :sprints, dependent: :destroy

  has_many :attachments, dependent: :destroy
  scope :favorite, -> { where(favorite: true) }
  scope :non_favorite, -> { where(favorite: false) }

  scope :recent, -> { order(updated_at: :desc) }
  scope :by_name, -> { order('LOWER(name)') }

  scope :exclude_project, ->(project) { where.not(id: project.id) }

  after_commit :owner_as_member

  scope :by_teams, ->(teams) { where(team_id: teams.pluck(:id)) }
  after_initialize :default_starting_date
  after_create :create_default_sprints
  after_update :sprints_based_on_velocity, if: :velocity_changed?

  def total_points
    user_stories_points - inactive_groups_points
  end

  def total_cost
    velocity_number = velocity.to_f
    return 0 unless velocity_number != 0.0 && cost_per_week
    cost_per_week * (total_points / velocity_number).ceil
  end

  def total_weeks
    velocity_number = velocity.to_f
    return 0 unless velocity_number != 0.0
    (total_points / velocity_number).ceil
  end

  def points_per_week
    points = total_points
    return points if velocity.blank? || velocity > points

    velocity
  end

  def name_url_hash
    {
      label: name,
      value: Rails.application.routes.url_helpers
        .arbor_reloaded_project_user_stories_path(self)
    }
  end

  def invite_exists(email)
    invites.any? { |invite| invite.email == email }
  end

  def assign_team(selected_team_name, current_user)
    if selected_team_name.blank?
      self.owner = current_user
    else
      team = current_user.teams.find_by(name: selected_team_name)
      self.team = team
      assign_team_owner(team)
    end
  end

  def assign_team_owner(team)
    team_owner = team.owner
    self.owner = team_owner
    members << team_owner
  end

  def add_member(user)
    return if members.include?(user)
    create_activity :add_member,
      parameters: { element: user.log_description }
    members << user
  end

  def reorder_user_stories(user_stories_hash)
    user_stories.update_all backlog_order: nil

    user_stories_hash.values.each do |story|
      story_group = story['group_id']
      group_from_hash = story_group ? story_group.to_i : nil
      UserStory
        .find(story['id'].to_i)
        .update_attributes!(backlog_order: story['backlog_order'].to_i,
                            group_id: group_from_hash)
    end
  end

  def ungrouped_user_stories?
    user_stories.ungrouped.any?
  end

  def copy_canvas(replica)
    canvas.copy_in_project(replica.id)
  end

  def clean_log
    activities.delete_all
    create_activity :create_project
  end

  def as_json(*_args)
    { id: id,
      name: name,
      user_stories: user_stories.backlog_ordered.map(&:as_json),
      starting_date: starting_date,
      errors: errors.full_messages }
  end

  def owner_as_member
    return if members.include? owner
    members << owner
  end

  def self.from_hash(hash, owner)
    owner.owned_projects.find_or_initialize_by(name: hash['name']) do |project|
      project.update_attributes(favorite: hash['favorite'],
                                velocity: hash['velocity'],
                                is_template: hash['is_template'])
      project.save
    end
  end

  def to_release_plan
    {
      name: name,
      sprints: sprints.includes(:user_stories).map(&:as_json),
      groups: groups.map(&:as_json),
      ungrouped_stories: user_stories.ungrouped.map(&:as_json)
    }
  end

  def create_default_sprints
    DEFAULT_SPRINTS_AMOUNT.times { sprints.create }
  end

  def sprints_based_on_velocity
    return unless sprints_empty?
    sprints_to_create =
      [DEFAULT_SPRINTS_AMOUNT, total_weeks].max - sprints.count

    sprints_to_create.times { sprints.create }
  end

  private

  def user_stories_points
    user_stories.map(&:estimated_points).compact.sum
  end

  def inactive_groups_points
    groups.inactive.map(&:total_estimated_points).sum
  end

  def default_starting_date
    self.starting_date = Time.now unless starting_date
  end

  def sprints_empty?
    !UserStory.joins(:sprints).where(sprints: { project_id: id }).any?
  end
end
