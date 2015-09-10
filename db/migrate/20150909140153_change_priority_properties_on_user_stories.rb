class ChangePriorityPropertiesOnUserStories < ActiveRecord::Migration
  def up
    change_column :user_stories, :priority, :string, limit: nil, default: 'should'

    translation = {
      'm' => 'must',
      's' => 'should',
      'c' => 'could',
      'w' => 'would'
    }

    PublicActivity.enabled = false
    UserStory.all.each do |user_story|
      user_story.update_attribute(:priority, translation[user_story.priority])
    end
    PublicActivity.enabled = true
  end

  def down
    change_column :user_stories, :priority, :string, limit: 1, default: 's'

    translation = {
      'must' => 'm',
      'should' => 's',
      'could' => 'c',
      'would' => 'w'
    }

    PublicActivity.enabled = false
    UserStory.all.each do |user_story|
      user_story.update_attribute(:priority, translation[user_story.priority])
    end
    PublicActivity.enabled = true
  end
end
