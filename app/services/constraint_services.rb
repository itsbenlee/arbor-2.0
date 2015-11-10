class ConstraintServices
  def initialize(user_story)
    @user_story = user_story
    @common_response = CommonResponse.new(true, [])
    @route_helper = Rails.application.routes.url_helpers
  end

  def new_constraint(constraint_params)
    constraint = Constraint.new(constraint_params)
    constraint.user_story = @user_story
    constraint.order = get_order(@user_story)

    if constraint.save
      assign_common_response(constraint)
    else
      @common_response.success = false
      @common_response.errors += constraint.errors.full_messages
    end
    @common_response
  end

  def update_constraint(constraint)
    if constraint.save
      @common_response.data[:edit_url] =
        @route_helper.edit_user_story_path(@user_story)
    else
      @common_response.success = false
      @common_response.errors += constraint.errors.full_messages
    end
    @common_response
  end

  def delete_constraint(constraint)
    if constraint.delete
      @common_response.data[:edit_url] =
        @route_helper.edit_user_story_path(@user_story)
    else
      @common_response.success = false
      @common_response.errors += constraint.errors.full_messages
    end
    @common_response
  end

  def reorder_constraints(constraint_params)
    new_order = constraint_params['constraints']
    @user_story.reorder_constraints(new_order)
    { success: true }
  end

  private

  def assign_common_response(constraint)
    @user_story.constraints << constraint
    @common_response.data[:edit_url] =
      @route_helper.edit_user_story_path(@user_story)
  end

  def get_order(user_story)
    existent_constraints = user_story.constraints
    if existent_constraints.present?
      existent_constraints.maximum('order') + 1
    else
      1
    end
  end
end
