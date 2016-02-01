module ApiSlack
  class SlackServices
    def initialize(token)
      @common_response = CommonResponse.new(true, [])
      @token = token
    end

    def parse_channels_list(channels_list_response)
      working_channels = channels_list_response['channels']
                         .find_all { |channel| !channel['is_archived'] }
      @common_response.data[:working_channels] =
        working_channels.to_json(only: ['name', 'id'])
      @common_response
    end
  end
end
