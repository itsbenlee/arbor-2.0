require 'spec_helper'

feature 'Log hypothesis activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :hypothesis }
    let(:update_field) { :description }
  end
end
