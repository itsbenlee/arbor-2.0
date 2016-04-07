module ArborReloaded
  include Rails.application.routes.url_helpers
  include HTTParty
  class SlackIntegrationService
    def initialize(project)
      @common_response = CommonResponse.new(true, [])
      @project = project
      set_urls
    end

    def build_user_story(story_text, current_user)
      normalized_us_text = story_text.downcase.squish
      user_story_service = ArborReloaded::UserStoryService.new(@project)
      if normalized_us_text.strip.length > 0
        @common_response = user_story_service.new_user_story(
          parse_new_user_story(normalized_us_text),
          current_user
        )
      else
        @common_response.success = false
        fail('EMPTY')
      end
      @common_response
    end

    def authorize(redirect_uri)
      options = {
        scope: 'commands incoming-webhook',
        client_id: ENV['SLACK_CLIENT_ID'],
        redirect_uri: redirect_uri
      }
      uri = URI(@auth_url)
      uri.query = URI.encode_www_form(options)
      uri.to_s
    end

    def req_slack_access(code, redirect_url)
      options = {
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: code,
        redirect_uri: redirect_url
      }
      response = HTTParty.get(@auth_access_url, query: options)
      response
    end

    def req_slack_data(token)
      options = {
        token: token
      }
      response = HTTParty.get(@data_url, query: options)
      response
    end

    def comment_notify(user_story_id, comment)
      comment_text = I18n.translate('slack.notifications.comment_created',
        user_story_id: user_story_id)
      HTTParty.post(@project.slack_iw_url, body: {
        text: comment_text,
        attachments: [
          {
            title: comment_text,
            text: comment,
            color: '#2FA44F'
          }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    def user_story_notify(user_story)
      @user_story = user_story
      HTTParty.post(@project.slack_iw_url, body: {
        attachments: [
          {
            title: I18n.translate('slack.notifications.story_created'),
            text: I18n.translate('slack.notifications.user_story',
              user_story: @user_story.log_description,
              link: Rails.application.routes.url_helpers
                .arbor_reloaded_project_user_stories_url(@project,
                host: 'getarbor.io')),
            color: '#28D7E5'
          }
        ]
      }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    private

    def parse_new_user_story(story_text)
      user_story_statics = { priority: 'should' }
      if story_text.match(regex_hash[:role_regexp])
        user_story = base_user_story(story_text, regex_hash)
      else
        user_story = { description: story_text }
      end
      user_story_statics.merge(user_story)
    end

    def base_user_story(story_text, regex)
      {
        role: story_text.match(regex[:role_regexp])[2].to_s.strip,
        action: story_text.match(regex[:action_regexp])[2].to_s.strip,
        result: story_text.match(regex[:result_regexp])[2].to_s.strip
      }
    end

    def set_urls
      @auth_url = ENV['SLACK_AUTH_URL']
      @auth_access_url = ENV['SLACK_ACCESS_URL']
      @data_url = ENV['SLACK_DATA_URL']
    end

    def regex_hash
      roles = I18n.translate('slack.user_story.role').join('|')
      actions = I18n.translate('slack.user_story.action').join('|')
      results = I18n.translate('slack.user_story.result').join('|')
      {
        role_regexp: /(#{roles})[n]? (.*?)(#{actions})/i,
        action_regexp: /(#{actions}) (.*?)(#{results})/i,
        result_regexp: /(#{results})\s+(.*)/i
      }
    end
  end
end
