require 'spec_helper'

feature 'Log constraint activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :constraint }
    let(:update_field) { :description }
  end
end
