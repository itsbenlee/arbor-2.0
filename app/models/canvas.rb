class Canvas < ActiveRecord::Base
  belongs_to :project
  nilify_blanks before: :save

  QUESTIONS = %i(problems solutions alternative advantage segment channel
                 value_proposition revenue_streams cost_structure)

  def copy_in_project(new_id)
    replica = dup
    replica.update_attributes(project_id: new_id)
  end
end
