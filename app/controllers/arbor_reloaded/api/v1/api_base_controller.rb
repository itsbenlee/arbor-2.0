module ArborReloaded
  module Api
    module V1
      class ApiBaseController < ActionController::Base
        protect_from_forgery with: :null_session
        skip_before_filter :verify_authenticity_token
        before_action :restrict_access

        respond_to :json

        rescue_from ActiveRecord::RecordNotFound do |error|
          json_response({ message: error.message }, :not_found)
        end

        protected

        def json_response(object, status = :ok)
          render json: object, status: status
        end

        def current_user
          @api_key.try(:user)
        end

        def restrict_access
          authenticate_or_request_with_http_token do |token|
            @api_key = ApiKey.find_by_access_token(token)
            ApiKey.exists?(access_token: token)
          end
        end
      end
    end
  end
end
