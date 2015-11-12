require 'spec_helper'

feature 'Log comment activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :comment }
    let(:update_field) { :comment }
  end
end
