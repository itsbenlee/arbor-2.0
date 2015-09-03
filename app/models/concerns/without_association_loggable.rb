module WithoutAssociationLoggable
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model

    tracked(
      on:        { update: proc { |model, _controller| model.changed? } },
      owner:     proc { |controller, _model| controller.current_user },
      recipient: proc { |_controller, model| model.recipient },
      value:     proc do |controller, model|
        if %w(create update destroy).include?(controller.action_name)
          model.log_description
        end
      end
    )
  end
end
