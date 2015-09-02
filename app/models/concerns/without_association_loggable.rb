module WithoutAssociationLoggable
  extend ActiveSupport::Concern

  included do
    include PublicActivity::Model

    tracked(
      owner: proc { |controller, _model| controller.current_user },
      on:    { update: proc { |model, _controller| model.changed? } }
    )
  end
end
