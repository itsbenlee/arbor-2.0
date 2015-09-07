require 'spec_helper'

RSpec.describe User do
  let(:user) { create :user }
  subject    { user }

  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should have_many(:projects) }
  it { should have_many(:owned_projects) }

  it_behaves_like 'a logged entity' do
    let(:entity)      { build :user, email: 'test@mail.com' }
    let(:description) { 'test@mail.com' }
  end
end
