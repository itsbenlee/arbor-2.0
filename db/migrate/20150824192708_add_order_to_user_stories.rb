class AddOrderToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :order, :integer
    Hypothesis.all.each do |hypothesis|
      hypothesis.user_stories.each_with_index do |user_story, index|
        user_story.update_attribute(:order, index + 1) if user_story.order.nil?
      end
    end
  end
end
