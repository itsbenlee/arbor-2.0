class Goal < ActiveRecord::Base
  include WithoutAssociationLoggable

  validates_presence_of :title

  belongs_to :hypothesis

  def log_description
    title
  end

  def recipient
    hypothesis
  end
end
