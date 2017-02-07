require 'spec_helper'

feature 'Updates tab', js:true do
  let!(:user) { create :user,
    full_name: 'Jhon Doe',
    email: 'jhon.doe@mail.com'
  }

  context 'As a User logged' do
    background do
      sign_in user
      visit arbor_reloaded_root_path
    end

    context 'oppening the page for first time' do
      scenario 'I should see the updates popup' do
        expect(page).to have_css('.top-bar-section .new-updates')
        expect(page).to have_text('NEW PRODUCT UPDATES')
      end

      context 'clicking Dismiss' do
        before do
          within('.top-bar-section .new-updates') do
            click_link('Dismiss')
            wait_for_ajax
          end
        end

        scenario 'should hide popup menu' do
          expect(page).to_not have_css('.top-bar-section .new-updates')
          expect(page).to_not have_text('NEW PRODUCT UPDATES')
        end

        context 're visiting the site' do
          scenario 'should not display the popup' do
            visit arbor_reloaded_root_path

            expect(page).to_not have_css('.top-bar-section .new-updates')
            expect(page).to_not have_text('NEW PRODUCT UPDATES')
          end
        end
      end

      context 'clicking Learn More' do
        before do
          within('.top-bar-section .new-updates') do
            click_link('Learn More')
            wait_for_ajax
          end
        end

        scenario 'should hide popup menu' do
          expect(page).to_not have_css('.top-bar-section .new-updates')
          expect(page).to_not have_text('NEW PRODUCT UPDATES')
        end

        context 're visiting the site' do
          scenario 'should not display the popup' do
            visit arbor_reloaded_root_path

            expect(page).to_not have_css('.top-bar-section .new-updates')
            expect(page).to_not have_text('NEW PRODUCT UPDATES')
          end
        end
      end
    end
  end
end
