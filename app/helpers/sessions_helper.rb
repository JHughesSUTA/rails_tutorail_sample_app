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

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
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

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Logs out the current user.
  def log_out
    forget(current_user)  # uses the forget helper above
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end