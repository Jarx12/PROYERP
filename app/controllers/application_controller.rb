class ApplicationController < ActionController::Base
  include Authorization

  before_action :require_login
  helper_method :current_user, :logged_in?, :public_layout?

  private

  def public_layout?
    controller_name == "pages" && %w[home about soluciones contactanos proyectos].include?(action_name)
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      flash[:alert] = "Debes iniciar sesión para acceder al sistema."
      redirect_to login_path
    end
  end
end
