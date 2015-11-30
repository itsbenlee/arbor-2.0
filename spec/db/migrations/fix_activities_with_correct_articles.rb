require 'spec_helper'
require 'migration_data/testing'
require_migration 'fix_activities_with_correct_articles'

describe FixActivitiesWithCorrectArticles do
  describe '#data' do
    it 'works' do
      expect { described_class.new.data }.to_not raise_exception
    end
  end
end
