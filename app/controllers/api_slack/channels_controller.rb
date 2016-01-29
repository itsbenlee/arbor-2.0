module ApiSlack
  include HTTParty
  class ChannelsController < ApplicationController
    layout false
    skip_before_filter :verify_authenticity_token
    skip_before_action :authenticate_user!
    protect_from_forgery with: :null_session

    def index
      token = channels_params[:token]
      channels_list_response =
        HTTParty.get("https://slack.com/api/channels.list?token=#{token}")
      if channels_list_response['ok']
        response = ApiSlack::SlackServices.new(token).parse_channels_list(
          channels_list_response
        )

        render json: response
      else
        render json: CommonResponse.new(false,
          [channels_list_response['error']]), status: false
      end
    end

    private

    def channels_params
      params.permit(:token)
    end
  end
end
