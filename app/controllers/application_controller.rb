class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  protect_from_forgery with: :exception

  # skip CSRF for OmniAuth
  skip_before_action :verify_authenticity_token, if: -> { request.path =~ %r{^/auth/} }
  
  allow_browser versions: :modern

  # Make these methods available in views
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end
  private

  def require_login
    unless logged_in?
      redirect_to root_path, alert: "You must be logged in to access that page."
    end
  end
end
