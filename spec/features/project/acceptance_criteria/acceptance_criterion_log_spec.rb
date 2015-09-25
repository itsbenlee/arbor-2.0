require 'spec_helper'

feature 'Log acceptance criterion activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :acceptance_criterion }
    let(:update_field) { :description }
  end
end
