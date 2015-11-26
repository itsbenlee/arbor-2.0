require 'spec_helper'
require 'migration_data/testing'
require_migration 'add_order_to_acceptance_criterion'

describe AddOrderToAcceptanceCriterion do
  describe '#data' do
    it 'works' do
      expect { described_class.new.data }.to_not raise_exception
    end
  end
end
