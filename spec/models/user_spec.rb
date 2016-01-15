require 'spec_helper'

RSpec.describe User do
  let(:user) { create :user }
  subject    { user }

  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
  it { should validate_uniqueness_of :slack_id }
  it { should have_many(:projects) }
  it { should have_many(:owned_projects) }
end
