require 'spec_helper'

feature 'Log user_story activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :user_story }
    let(:update_field) { :role }
  end
end
