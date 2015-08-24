class Goal < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :hypothesis
end
