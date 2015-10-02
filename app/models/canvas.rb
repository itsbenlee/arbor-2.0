class Canvas < ActiveRecord::Base
  belongs_to :project
  nilify_blanks before: :save

  QUESTIONS = %i(problems solutions alternative advantage segment channel
                 value_proposition revenue_streams cost_structure)

  def completed_percentage
    return 100 if complete?
    percentage = 0
    percentage_to_add = (100 / QUESTIONS.length).round

    QUESTIONS.each do |question|
      percentage += percentage_to_add if try(question)
    end
    percentage
  end

  def copy_in_project(new_id)
    replica = dup
    replica.update_attributes(project_id: new_id)
  end

  private

  def complete?
    complete = true
    QUESTIONS.each { |question| complete = false unless try(question) }
    complete
  end
end
