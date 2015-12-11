class Goal < ActiveRecord::Base
  validates_presence_of :title

  belongs_to :hypothesis

  def log_description
    title
  end

  def copy_in_hypothesis(new_id)
    replica = dup
    replica.update_attributes(hypothesis_id: new_id)
  end
end
