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

  include AssociationLoggable

  has_many :attachments, dependent: :destroy

  def as_json
    super(only: [:name])
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
end
