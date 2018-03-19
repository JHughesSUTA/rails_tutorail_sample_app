module SessionsHelper

  # logs the given user in
  def log_in(user)      # defined here because we will use it in a few places
    session[:user_id] = user.id
  end

  # Logs the current user out
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end
end
