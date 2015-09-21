require 'spec_helper'

feature 'Meta tags on project page' do
  it_behaves_like 'a meta tagged page' do
    let(:user) { create :user }
  end
end
