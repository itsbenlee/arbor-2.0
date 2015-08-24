class HypothesisType < ActiveRecord::Base
  validates_presence_of :code, :description
  validates_uniqueness_of :code, :description

  has_many :hypotheses, dependent: :destroy

  def as_json
    super(only: [:description])
  end
end
