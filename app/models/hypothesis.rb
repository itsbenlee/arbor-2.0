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
  delegate :name, to: :project, prefix: true

  include AssociationLoggable

  def self.new_order(hypothesis_hash)
    hypothesis = Hypothesis.find(hypothesis_hash[:id])
    hypothesis.order = hypothesis_hash[:order]
    hypothesis.save
  end

  def self.to_csv(hypotheses, options = {})
    CSV.generate(options) do |csv|
      hypotheses.each do |hypothesis|
        hypothesis_csv(csv, hypothesis)
        goals_csv(csv, hypothesis.goals)
        user_story_csv(csv, hypothesis.user_stories)
        csv << %w(- - - - -)
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

  def self.goals_csv(csv, goals)
    csv << %w(goal_title)
    goals.each do |goal|
      csv << [goal.title]
    end
  end

  def self.user_story_csv(csv, user_stories)
    csv << %w(user_story_points
              user_story_priority
              user_story_role
              user_story_action
              user_story_result)
    user_stories.each do |user_story|
      csv << [user_story.estimated_points,
              user_story.priority,
              user_story.role,
              user_story.action,
              user_story.result]
    end
  end

  def self.hypothesis_csv(csv, hypothesis)
    csv << %w(hypothesis_description
              hypothesis_project
              hypothesis_type
              order)
    csv << [hypothesis.description,
            hypothesis.project_name,
            hypothesis.hypothesis_type_description,
            hypothesis.order]
  end
end
