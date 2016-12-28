class Group < ActiveRecord::Base
  belongs_to :project
  has_many :user_stories

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false, scope: :project_id
  validates_length_of :name, maximum: 100

  before_destroy :ungroup_stories

  def ungroup_stories
    user_stories.update_all group_id: nil
  end

  def deep_duplication(new_project)
    new_project.groups.concat(dup)
    user_stories.each { |story| story.copy_in_project(new_project) }
  end

  def add_ungrouped_stories
    project.user_stories.ungrouped.update_all(group_id: id)
  end
end
