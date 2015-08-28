RSpec.shared_examples 'a loggable entity' do
  feature 'Log entity activity' do
    let!(:user)      { create :user }
    let(:entity_key) { entity.class.table_name.singularize }

    background do
      sign_in user
    end

    scenario 'should log entity creation' do
      PublicActivity.with_tracking do
        entity
      end

      activity_keys = PublicActivity::Activity.all.pluck(:key)
      expect(activity_keys).to include "#{entity_key}.create"
    end

    scenario 'should log entity deletion' do
      entity
      PublicActivity.with_tracking do
        entity.destroy
      end

      activities = PublicActivity::Activity.all
      expect(activities.count).to eq 1
      expect(activities.first.key).to eq "#{entity_key}.destroy"
    end

    scenario 'should log entity update' do
      entity
      PublicActivity.with_tracking do
        entity.update_attribute(update_field, 'new_value')
      end

      activities = PublicActivity::Activity.all
      expect(activities.count).to eq 1
      expect(activities.first.key).to eq "#{entity_key}.update"
    end

    scenario 'should not log entity update if the data does not change' do
      entity
      PublicActivity.with_tracking do
        entity.update_attribute(update_field, entity.try(update_field))
      end

      activities = PublicActivity::Activity.all
      expect(activities).to be_empty
    end
  end
end
