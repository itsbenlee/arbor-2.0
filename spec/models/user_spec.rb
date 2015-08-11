require 'spec_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  subject    { user }

  it { should validate_presence_of :full_name }
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of :email }
end
