require 'jira'

module ArborReloaded
  class JiraServices
    def initialize(_project = nil)
      @project = _project
      @common_response = CommonResponse.new(true)
    end

    def authenticate(username, password, site)
      options = {
        username: username,
        password: password,
        site: site,
        context_path: '',
        auth_type: :basic
      }

      @client = JIRA::Client.new(options)
      authenticate_client
      @common_response
    end

    private

    def authenticate_client
      # TODO: Should we export the project here and test the connection???
      @client.Project.all
      @common_response.data[:client] = @client
    rescue JIRA::HTTPError
      @common_response.success = false
      @common_response.errors << I18n.t('jira.authentication_error')
    end
  end
end
