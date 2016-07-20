class Comment < ActiveRecord::Base
  include PublicActivity::Common
  include ActsAsCommentable::Comment
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :user_story
  validates_presence_of :comment

  scope :recent, -> { order(created_at: :desc) }

  def log_description
    comment
  end

  def user_name
    user.full_name
  end

  def as_json(*_args)
    { comment: comment, user_id: user.id, created_at: created_at }
  end
end
