RSpec.shared_examples 'a meta tagged page' do
  context 'without meta tags set' do
    background do
      ENV['META_TITLE'] = nil
      ENV['META_DESCRIPTION'] = nil
      sign_in user if user
      visit '/'
    end

    scenario 'shows the meta title' do
      expect(page).to have_title 'Arbor'
    end

    scenario 'shows the meta description' do
      expect(page).to have_meta(:description, 'Add meta description')
    end
  end

  context 'with meta tags set' do
    background do
      ENV['META_TITLE'] = 'Arbor v.2'
      ENV['META_DESCRIPTION'] = 'Rootstrapping easily done'
      sign_in user if user
      visit '/'
    end

    scenario 'shows the meta title' do
      expect(page).to have_title 'Arbor v.2'
    end

    scenario 'shows the meta description' do
      expect(page).to have_meta(:description, 'Rootstrapping easily done')
    end
  end
end
