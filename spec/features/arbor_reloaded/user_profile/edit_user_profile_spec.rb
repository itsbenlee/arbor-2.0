require 'spec_helper'

feature 'User profile', js:true do
  let!(:user) { create :user,
    full_name: 'Jhon Doe',
    email: 'jhon.doe@mail.com'
  }

  background do
    sign_in user
    visit arbor_reloaded_user_path(user)
  end

  scenario 'Text fields should be disabled at first, and the only button visible will be Edit' do
    expect(page.evaluate_script("$('#user_full_name').attr('disabled')")).to eq('disabled')
    expect(page.evaluate_script("$('#user_email').attr('disabled')")).to eq('disabled')

    expect(page).to have_selector('#edit-user-profile-btn', visible: true)
    expect(page).to have_selector('#save-user-profile', visible: false)
    expect(page).to have_selector('#cancel-btn', visible: false)
  end

  scenario 'Text fields will be enabled once the user clicks the Edit button
    (it will disappear), also Save and Cancel buttons will appear' do
    find('#edit-user-profile-btn').trigger('click')

    expect(page.evaluate_script("$('#user_full_name').attr('disabled')")).to_not eq('disabled')
    expect(page.evaluate_script("$('#user_email').attr('disabled')")).to_not eq('disabled')

    expect(page).to have_selector('#edit-user-profile-btn', visible: false)
    expect(page).to have_selector('#save-user-profile', visible: true)
    expect(page).to have_selector('#cancel-btn', visible: true)
  end

  scenario 'The user changes his info and the page reflects the changes' do
    expect(page.evaluate_script("$('#user_full_name').val()")).to eq('Jhon Doe')
    expect(page.evaluate_script("$('#user_email').val()")).to eq('jhon.doe@mail.com')

    find('#edit-user-profile-btn').trigger('click')

    find("#user_full_name").set 'Jhon Doe The Second'
    find("#user_email").set 'jhon.doe.second@mail.com'
    find('#save-user-profile').trigger('click')

    expect(page.evaluate_script("$('#user_full_name').val()")).to eq('Jhon Doe The Second')
    expect(page.evaluate_script("$('#user_email').val()")).to eq('jhon.doe.second@mail.com')
  end

  scenario 'When the user does not have an avatar defined the initial
    of his name should appear as avatar' do
    within find('.user-header') do
      expect(page.evaluate_script("$('#avatar-circle').text()")).to eq('J')
    end
  end

  scenario 'I should have my api key' do
    expect(page.evaluate_script("$('#arbor-token-field').text()")).to eq(user.access_token)
  end

  scenario 'I should see the copy token button' do
    expect(page).to have_content('Copy access token')
  end
end
