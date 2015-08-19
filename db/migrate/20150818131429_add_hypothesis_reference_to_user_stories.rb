class AddHypothesisReferenceToUserStories < ActiveRecord::Migration
  def change
    add_reference :user_stories, :hypothesis, index: true
  end
end
