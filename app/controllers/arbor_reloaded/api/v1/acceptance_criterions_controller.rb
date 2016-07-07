module ArborReloaded
  module Api
    module V1
      class AcceptanceCriterionsController < ApiBaseController
        before_action :set_user_story

        def create
          params[:acceptance_criterions].each do |acceptance_criteria|
            ac_params = acceptance_criteria.permit(:description)
            @user_story.acceptance_criterions.find_or_create_by(ac_params)
          end

          render json: @user_story.as_json
        end

        private

        def set_user_story
          @user_story = current_user.user_stories.find(params[:user_story_id])
        end
      end
    end
  end
end
