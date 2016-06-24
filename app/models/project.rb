class Project < ActiveRecord::Base
  include PublicActivity::Common

  validates_presence_of :name
  validates_uniqueness_of :name,
                          scope: :owner,
                          message: 'Project name already exists'
  validates_uniqueness_of :slack_channel_id, allow_nil: true
  validates_uniqueness_of :slack_iw_url, allow_nil: true
  validates_uniqueness_of :is_template,
    if: proc { |project| project.is_template }

  belongs_to :owner, class_name: User
  belongs_to :team
  has_one :canvas, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :user_stories, dependent: :destroy
  has_many :members_projects, class_name: MembersProject
  has_many :members, class_name: User, through: :members_projects
  has_many :groups

  has_many :attachments, dependent: :destroy
  scope :favorite, -> { where(favorite: true) }
  scope :non_favorite, -> { where(favorite: false) }

  scope :recent, -> { order(updated_at: :desc) }
  scope :by_name, -> { order('LOWER(name)') }

  after_commit :owner_as_member

  def total_points
    user_stories.map(&:estimated_points).compact.sum
  end

  def total_cost
    return 0 unless velocity && cost_per_week
    cost_per_week * (total_points / velocity.to_f).ceil
  end

  def total_weeks
    return 0 unless velocity
    (total_points / velocity.to_f).ceil
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
end
