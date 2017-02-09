class ApplicationController < ActionController::Base
  include PublicActivity::StoreController

  protect_from_forgery with: :exception
  before_action :authenticate_user!, :current_user_projects,
    unless: :admin_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :layout_by_resource
  force_ssl if: :ssl_configured?
  before_action :updates_status

  private

  def ssl_configured?
    Rails.env.production? && ENV['FORCE_SSL'] == 'true'
  end

  protected

  def updates_status
    @dismiss_updates = session['dismiss_updates']
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :full_name
    devise_parameter_sanitizer.for(:account_update) << %i(full_name avatar)
  end

  def current_user_projects
    return unless current_user
    @projects = current_user.projects
  end

  def layout_by_resource
    devise_controller? ? 'guest' : 'application'
  end

  def admin_controller?
    params[:controller].include? 'rails_admin'
  end
end
