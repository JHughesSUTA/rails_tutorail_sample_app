module SessionsHelper

  # logs the given user in
  def log_in(user)      # defined here because we will use it in a few places
    session[:user_id] = user.id
  end

  # remembers a users in a persistent session
  def remember(user)
    user.remember     # generates a remember token and and saves digest to the database
    cookies.permanent.signed[:user_id] = user.id      # creates permanent token for user id
    cookies.permanent[:remember_token] = user.remember_token  # creates permeanent token for remember token
  end

  # Logs the current user out
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    if (user_id = session[:user_id])  # “If session of user id exists (while setting user id to session of user id)…”.
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # current_user can also be written like this - less confusing but not super dry:
  # def current_user
  #   if session[:user_id]
  #     @current_user ||= User.find_by(id: session[:user_id])
  #   elsif cookies.signed[:user_id]
  #     user = User.find_by(id: cookies.signed[:user_id])
  #     if user && user.authenticated?(cookies[:remember_token])
  #       log_in user
  #       @current_user = user
  #     end
  #   end
  # end

  def logged_in?
    !current_user.nil?
  end
end