class AcceptanceCriterionServices
  def initialize(user_story)
    @user_story = user_story
    @common_response = CommonResponse.new(true, [])
    @route_helper = Rails.application.routes.url_helpers
  end

  def new_acceptance_criterion(acceptance_criterion_params)
    acceptance_criterion = AcceptanceCriterion.new(acceptance_criterion_params)
    acceptance_criterion.user_story = @user_story

    if acceptance_criterion.save
      assign_common_response(acceptance_criterion)
    else
      @common_response.success = false
      @common_response.errors += acceptance_criterion.errors.full_messages
    end
    @common_response
  end

  private

  def assign_common_response(acceptance_criterion)
    @user_story.acceptance_criterions << acceptance_criterion
    @common_response.data[:edit_url] =
      @route_helper.edit_user_story_path(@user_story)
  end
end
