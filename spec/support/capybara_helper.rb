module Capybara
  module Auth
    module Helpers
      include Capybara::DSL

      def sign_in(user)
        Warden.test_mode!

        visit new_user_session_path
        find('#user_email.login').set user.email
        find('#user_password.login').set user.password
        find('#login_button').click()

        user
      end
    end
  end
end
