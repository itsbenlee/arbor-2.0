class Project < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  belongs_to :owner, class_name: User
  has_one :canvas, dependent: :destroy
  has_many :hypotheses, dependent: :destroy
  has_many :invites, dependent: :destroy
  has_many :user_stories, dependent: :destroy
  has_many :members_projects, class_name: MembersProject
  has_many :members, class_name: User, through: :members_projects
  has_many :tags

  include AssociationLoggable

  has_many :attachments, dependent: :destroy

  def as_json
    super(only: [:name])
  end

  def invite_exists(email)
    invites.any? { |invite| invite.email == email }
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

  def recipient
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

  def clean_log(current_user)
    activities.delete_all
    create_activity key: 'project.copied', owner: current_user
    [clean_stories_log, clean_hypotheses_log].each(&:join)
  end

  private

  def clean_stories_log
    Thread.new { user_stories.each(&:clean_log) }
  end

  def clean_hypotheses_log
    Thread.new { hypotheses.each(&:clean_log) }
  end
end
