require 'spec_helper'

RSpec.describe Team, type: :model do
  let(:team) { create :team }
  subject    { team }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of(:name) }
  it { should have_many :users }
  it { should belong_to :owner }
end
