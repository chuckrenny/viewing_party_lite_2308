class ApplicationController < ActionController::Base
  add_flash_types :alert
  helper_method :current_user

  def current_user
    @_current_user ||= User.find(session[:user_id]) if session[:user_id]
  rescue
    session.clear
    @_current_user = nil
  end
end
