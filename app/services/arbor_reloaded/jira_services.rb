require 'jira-ruby'

module ArborReloaded
  class JiraServices
    def initialize(token, secret)
      @client = create_client(token, secret)
    end

    def start_authentication(callback_url)
      p callback_url
      request_token = @client.request_token(oauth_callback: callback_url)

      return {
        token: request_token.token,
        secret: request_token.secret,
        errors: [],
        url: request_token.authorize_url
      }
    end

    def authenticate(oauth_verifier)
      @jira_client.init_access_token(
        :oauth_verifier => oauth_verifier
      )
    end

    private

    def create_client(token, secret)
      # add any extra configuration options for your instance of JIRA,
      # e.g. :use_ssl, :ssl_verify_mode, :context_path, :site
      options = {
        :private_key_file => ENV.fetch("JIRA_KEY_FILE_PATH"), #"rsakey.pem",
        :consumer_key => ENV.fetch("JIRA_CONSUMER_KEY"), #'test'
      }

      JIRA::Client.new(options).tap do |client|
        client.set_access_token(token, secret) if token && secret
      end
    end
  end
end
