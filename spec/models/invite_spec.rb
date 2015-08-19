require 'spec_helper'

describe Invite do
  let(:invite) { create :invite }

  it { should validate_presence_of :email }
  it { should validate_presence_of :project }
  it { should belong_to :project }
end
