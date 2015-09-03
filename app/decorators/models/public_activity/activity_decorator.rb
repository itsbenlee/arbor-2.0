PublicActivity::Activity.class_eval do
  def crud_action?
    %w(create update destroy).include? action_name
  end

  private

  def action_name
    key.split('.').last
  end
end
