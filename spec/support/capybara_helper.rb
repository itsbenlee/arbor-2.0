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

      def sign_out
        visit arbor_reloaded_projects_path

        within '.top-bar' do
          find('.icn-signout').trigger('click')
        end

        sleep 0.5
      end

      def sign_up(email, password = Faker::Internet.password, username = Faker::Internet.user_name)
        create :project, is_template: true
        allow_any_instance_of(ArborReloaded::IntercomServices).to receive(:user_create_event).and_return(true)
        visit new_user_registration_path

        within '#signup' do
          fill_in :user_full_name, with: username
          fill_in :user_email, with: email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          find('#sign-up-button').click
        end
      end
    end
  end
end
