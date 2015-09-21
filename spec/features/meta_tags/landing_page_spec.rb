require 'spec_helper'

feature 'Meta tags on landing page' do
  it_behaves_like 'a meta tagged page' do
    let(:user) { nil }
  end
end
