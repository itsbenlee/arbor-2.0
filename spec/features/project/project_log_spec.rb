require 'spec_helper'

feature 'Log project activity' do
  it_behaves_like 'a loggable entity' do
    let(:entity)       { create :project }
    let(:update_field) { :name }
  end
end
