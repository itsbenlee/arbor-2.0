require 'spec_helper'

RSpec.describe ApiKey, type: :model do
  let(:api_key) { create :api_key }
  subject       { api_key }

  it { should validate_uniqueness_of :access_token }
  it { should belong_to :user }
end
