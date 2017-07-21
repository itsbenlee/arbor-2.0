class SprintUserStory < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user_story

  validates_uniqueness_of :user_story_id, scope: :sprint_id

  STATUS = %w(PLANNED WIP DONE CARRYOVER)

  validates_presence_of :user_story, :sprint
  validates :status, inclusion: STATUS
  validate :sprint_story_are_in_project, if: -> { user_story && sprint }

  after_initialize do
    next unless new_record?
    next if status

    self.status = STATUS.first
  end

  def self.next_status(actual_status)
    actual_status_index = SprintUserStory::STATUS.find_index(actual_status)

    return 'PLANNED' unless actual_status_index

    SprintUserStory::STATUS[actual_status_index + 1]
  end

  private

  def sprint_story_are_in_project
    return if sprint.project_id == user_story.project_id
    errors.add(:base, :distinct_project)
  end
end
