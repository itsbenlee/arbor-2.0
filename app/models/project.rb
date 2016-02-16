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
  has_many :hypotheses, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :user_stories, dependent: :destroy
  has_many :members_projects, class_name: MembersProject
  has_many :members, class_name: User, through: :members_projects
  has_many :tags, dependent: :destroy

  has_many :attachments, dependent: :destroy
  scope :favorite, -> { where(favorite: true) }
  scope :non_favorite, -> { where(favorite: false) }

  scope :recent, -> { order(updated_at: :desc) }
  scope :by_name, -> { order('LOWER(name)') }

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

  def as_json
    super(only: [:name])
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
      self.team = current_user.teams.find_by(name: selected_team_name)
      self.owner = team.owner
    end
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
      UserStory
        .find(story['id'].to_i)
        .update_attributes!(backlog_order: story['backlog_order'].to_i)
    end
  end

  def log_description
  end

  def copy_stories(replica, old_hypothesis_id, hypothesis_replica_id)
    stories = user_stories.where(hypothesis_id: old_hypothesis_id)
    stories.each do |story|
      story.copy_in_project(replica.id, hypothesis_replica_id)
    end
  end

  def copy_canvas(replica)
    canvas.copy_in_project(replica.id)
  end

  def copy_hypothesis(replica)
    hypotheses.each do |hypothesis|
      hypothesis.copy_in_project(replica.id)
    end
  end

  def clean_log
    activities.delete_all
    create_activity :create_project
  end

  def undefined_hypothesis
    hypotheses
      .find_or_create_by(description: I18n.t('labs.undefined_hypothesis'))
  end
end
