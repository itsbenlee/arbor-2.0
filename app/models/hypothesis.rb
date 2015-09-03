class Hypothesis < ActiveRecord::Base
  validates_presence_of :description, :hypothesis_type, :project
  validates_uniqueness_of :description, scope: :project_id
  validates_uniqueness_of :order, scope: :project_id
  before_create :order_in_project

  belongs_to :project
  belongs_to :hypothesis_type
  has_many :user_stories
  has_many :goals, dependent: :destroy

  delegate :description, :code, to: :hypothesis_type, prefix: true

  include AssociationLoggable

  def self.new_order(hypothesis_hash)
    hypothesis = Hypothesis.find(hypothesis_hash[:id])
    hypothesis.order = hypothesis_hash[:order]
    hypothesis.save
  end

  def self.to_csv(hypotheses, options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      hypotheses.each do |hypothesis|
        csv << hypothesis.attributes.values_at(*column_names)
      end
    end
  end

  def as_json
    super(only: [:order, :description], methods: [:type])
  end

  def type
    hypothesis_type.as_json
  end

  def reorder_user_stories(user_stories_hash)
    user_stories.each { |user_story| user_story.update_attributes!(order: nil) }

    user_stories_hash.values.each do |story|
      UserStory
        .find(story['id'].to_i)
        .update_attributes!(hypothesis_id: id,
                            order: story['order'].to_i)
    end
  end

  def log_description
    description
  end

  def recipient
    project
  end

  private

  def order_in_project
    self.order = project.hypotheses.maximum(:order).to_i + 1
  end
end
