class HypothesisType < ActiveRecord::Base
  validates_presence_of :code, :description
  validates_uniqueness_of :code, :description

  has_many :hypotheses, dependent: :destroy
end
