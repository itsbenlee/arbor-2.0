class Comment < ActiveRecord::Base
  include ActsAsCommentable::Comment
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  validates_presence_of :comment

  def log_description
    comment
  end

  def assign_elements(comment_params, current_user)
    self.comment = comment_params[:comment]
    self.user = current_user
  end

  def user_name
    user.full_name
  end
end
