class Goal < ActiveRecord::Base
  include WithoutAssociationLoggable

  validates_presence_of :title

  belongs_to :hypothesis
end
