RSpec.shared_examples 'a logged entity' do
  describe 'log_description' do
    it "should build the entity description correctly" do
      expect(entity.log_description).to eq description
    end
  end
end
