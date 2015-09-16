require 'spec_helper'

feature 'Check version string' do
  let(:user) { create :user }

  background do
    ENV['VERSION'] = 'MY_VERSION'
    sign_in user
  end

  scenario 'sidebar version is displayed' do
    within 'aside#sidebar' do
      expect(
        find('p.arbor-version').text
      ).to have_text(I18n.t('sidebar.version') + 'MY_VERSION')
    end
  end
end
