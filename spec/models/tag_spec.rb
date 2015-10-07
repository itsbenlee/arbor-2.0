require 'spec_helper'

RSpec.describe Tag, type: :model do
  let(:tag) { create :tag }
  subject   { tag }

  it { should validate_presence_of :name }
  it { should validate_uniqueness_of :name }
  it { should have_and_belong_to_many :user_stories }
  it { should belong_to :project }
end
