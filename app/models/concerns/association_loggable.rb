module AssociationLoggable
  extend ActiveSupport::Concern

  included do
    include WithoutAssociationLoggable

    private

    def self.association_callback_fields
      fields = reflect_on_all_associations(:has_many).map(&:name).map(&:to_s)
      fields -= ['activities']
      fields.select! do |field|
        single_column_association?(field) || !through_association?(field)
      end

      fields
    end

    def self.single_column_association?(field)
      !field.include? '_'
    end

    def self.through_association?(field)
      field.split('_').all? do |column|
        column.pluralize == column
      end
    end

    %w(add remove).each do |action|
      association_callback_fields.each do |assoc_model|
        send(
          "after_#{action}_for_#{assoc_model}".to_sym
        ) << lambda do |_klass, object, assoc_object|
          key = "#{action}_#{assoc_model.singularize}"
          object.create_activity(
            key,
            recipient: (assoc_object if object.save),
            value: assoc_object.log_description
          )
        end
      end
    end
  end
end
