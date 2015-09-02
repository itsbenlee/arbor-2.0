require 'spec_helper'

feature 'Log goal activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :goal }
    let(:update_field) { :title }
  end
end
