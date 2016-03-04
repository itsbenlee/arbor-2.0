module ArborReloaded
  include HTTParty
  class SlackIntegrationService
    before_filter :set_urls
    ROLE = I18n.translate('reloaded.backlog.role')
    ACTION = I18n.translate('reloaded.backlog.action')
    RESULT = I18n.translate('reloaded.backlog.result')
    REGEXP_HASH = {
      role_regexp: /#{ROLE}[n]? (.*?)#{ACTION}/,
      action_regexp: /#{ACTION} (.*?)#{RESULT}/,
      result_regexp: /#{RESULT} (.*?)(.*)/
    }

    def initialize(project)
      @common_response = CommonResponse.new(true, [])
      @project = project
    end

    def build_user_story(story_text, current_user)
      user_story_service = ArborReloaded::UserStoryService.new(@project)
      if valid_message?(story_text)
        @common_response = user_story_service.new_user_story(
          parse_new_user_story(story_text),
          current_user
        )
      else
        @common_response.success = false
      end
      @common_response
    end

    def authorize(redirect_uri)
      options = {
        scope: 'commands incoming-webhook',
        client_id: ENV['SLACK_CLIENT_ID'],
        redirect_uri: redirect_uri
      }
      @auth_url.query = URI.encode_www_form(options)
      @auth_url.to_s
    end

    def req_slack_access(code, redirect_url)
      options = {
        client_id: ENV['SLACK_CLIENT_ID'],
        client_secret: ENV['SLACK_CLIENT_SECRET'],
        code: code,
        redirect_uri: redirect_url
      }
      response = HTTParty.get(@auth_access_url, options)
      response
    end

    def req_slack_data(token)
      options = {
        token: token
      }
      response = HTTParty.get(@data_url, options)
      response
    end

    private

    def valid_message?(story_text)
      errors = @common_response.errors
      errors.push(role_defined?(story_text))
      errors.push(action_defined?(story_text))
      errors.push(result_defined?(story_text))

      errors.compact.length == 0
    end

    def role_defined?(story_text)
      (story_text.downcase.exclude? ROLE.downcase) ? 'Missing Role' : nil
    end

    def action_defined?(story_text)
      (story_text.downcase.exclude? ACTION.downcase) ? 'Missing Action' : nil
    end

    def result_defined?(story_text)
      (story_text.downcase.exclude? RESULT.downcase) ? 'Missing Result' : nil
    end

    def parse_new_user_story(story_text)
      {
        role: story_text.match(REGEXP_HASH[:role_regexp])[1].to_s.strip,
        action: story_text.match(REGEXP_HASH[:action_regexp])[1].to_s.strip,
        result: story_text.match(REGEXP_HASH[:result_regexp])[0].to_s.strip,
        estimated_points: '',
        priority: 'should'
      }
    end

    def set_urls
      @auth_url = 'https://slack.com/oauth/authorize'
      @auth_access_url = 'https://slack.com/api/oauth.access'
      @data_url = 'https://slack.com/api/auth.test'
    end
  end
end
