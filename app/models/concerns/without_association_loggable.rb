module WithoutAssociationLoggable
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model

    tracked(
      on:        { update: proc { |model, _controller| model.changed? } },
      owner:     proc do |controller, _model|
        controller.current_user if controller
      end,
      recipient: proc { |_controller, model| model.recipient },
      value:     proc do |controller, model|
        if controller &&
          %w(create update destroy).include?(controller.action_name)
          model.log_description
        end
      end
    )
  end
end
