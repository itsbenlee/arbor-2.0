class SprintUserStory < ActiveRecord::Base
  belongs_to :sprint
  belongs_to :user_story

  validates_uniqueness_of :user_story_id, scope: :sprint_id
  validates_uniqueness_of :sprint_id, scope: :user_story_id

  STATUS = %w(PLANNED WIP DONE)

  validates_presence_of :status, :user_story, :sprint
  validates :status, inclusion: STATUS
  validate :sprint_story_are_in_project, if: -> { user_story && sprint }

  private

  def sprint_story_are_in_project
    return unless sprint.project_id != user_story.project_id
    errors.add(
      :base, "sprint and user story don't belong to the same project"
    )
  end
end
