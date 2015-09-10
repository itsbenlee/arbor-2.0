class AddNextStoryNumberForProjects < ActiveRecord::Migration
  def up
    add_column(
      :projects,
      :next_story_number,
      :integer,
      index:   :true,
      null:    false,
      default: 1
    )

    PublicActivity.enabled = false
    Project.all.each do |project|
      project.update_attribute(
        :next_story_number,
        project.user_stories.count + 1
        )
    end
    PublicActivity.enabled = true
  end

  def down
    remove_column :projects, :next_story_number
  end
end
