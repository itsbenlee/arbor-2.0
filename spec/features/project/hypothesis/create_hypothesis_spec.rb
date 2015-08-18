require 'spec_helper'

feature 'Create hypothesis' do
  background do
    @user = sign_in create :user
    @project = create :project, { owner: @user, members: [@user]}
    @hypothesis_type = create :hypothesis_type
    visit root_url

    within 'aside' do
      find('.project-link').click
    end
  end

  scenario 'with valid data' do
    hypothesis_description = 'My amazing hypothesis'

    within '.hypothesis-new' do
      find('.description').set(hypothesis_description)
      find('#hypothesis_hypothesis_type_id').select(@hypothesis_type.description)
      click_button 'Save'
    end

    within '.hypotheses-list' do
      expect(find('.description')).to have_text(hypothesis_description)
      expect(find('.order')).to have_text('1')
      expect(find('.type')).to have_text(@hypothesis_type.description)
    end
  end

  scenario 'should increment the bullet number when adding a hypothesis' do
    hypothesis_description = 'My amazing hypothesis'

    within '.hypothesis-new' do
      find('.description').set(hypothesis_description)
      find('#hypothesis_hypothesis_type_id').select(@hypothesis_type.description)
      click_button 'Save'
    end

    within '.hypotheses-list' do
      expect(find('.order')).to have_text('1')
    end

    within '.hypothesis-new' do
      expect(find('.order')).to have_text('2')
    end
  end

  scenario 'create hypothesis without description' do
    within '.hypothesis-new' do
      find('#hypothesis_hypothesis_type_id').select(@hypothesis_type.description)
      click_button 'Save'
    end

    expect(find('.hypothesis_errors ul li')).to have_text("Description can't be blank")
  end
end
