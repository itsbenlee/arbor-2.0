module ArborReloaded
  class CriterionServices
    def initialize(user_story)
      @user_story = user_story
    end

    def new_acceptance_criterion(acceptance_criterion_params)
      acceptance_criterion =
        AcceptanceCriterion.new(acceptance_criterion_params)
      acceptance_criterion.assign_story(@user_story)
      acceptance_criterion
    end
  end
end
