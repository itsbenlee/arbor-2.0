class Group < ActiveRecord::Base
  default_scope { order(:order) }

  attr_accessor :preset_order

  enum status: [:active, :inactive]

  belongs_to :project
  has_many :user_stories

  validates_presence_of :name
  validates_uniqueness_of :name, case_sensitive: false, scope: :project_id
  validates_length_of :name, maximum: 100
  validates_uniqueness_of :order, scope: :project_id,
                                  unless: -> { preset_order }

  before_create :move_down_project_groups, if: -> { order.present? }
  before_create :set_order, unless: -> { order.present? }
  before_destroy :move_up_project_groups
  before_destroy :ungroup_stories

  delegate :owner_id, to: :project

  after_update :track_group_changes

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

  def up
    move_group_order(-1)
  end

  def down
    move_group_order(1)
  end

  def total_estimated_points
    user_stories.sum(:estimated_points)
  end

  def opposite_status
    active? ? 'inactive' : 'active'
  end

  def as_json(*_args)
    {
      id: id,
      name: name,
      user_stories: user_stories.map(&:as_summarized_json),
      estimated_points: total_estimated_points
    }
  end

  private

  def set_order
    self.order = project.try(:groups).try(:count) || 0
  end

  def move_down_project_groups
    groups = project.groups.where('groups.order >= :order', order: order)
    groups.each { |group| group.update_attribute(:order, group.order + 1) }
  end

  def move_up_project_groups
    groups = project.groups.where('groups.order > :order', order: order)
    groups.each { |group| group.update_attribute(:order, group.order - 1) }
  end

  def move_group_order(step)
    new_order = order + step
    return unless (moved_group = project.groups.find_by(order: new_order))

    moved_group.update_attribute(:order, order)
    update_attribute(:order, new_order)
  end

  def track_group_changes
    tracker_services = Mixpanel::TrackerServices.new
    tracker_services.track_event(owner_id, 'USER_EDITS_THEME')
  end
end
