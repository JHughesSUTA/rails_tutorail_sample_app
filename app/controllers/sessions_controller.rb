class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)   # instance variables created because exercise 9.2
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        # remembers the logged-in user from sessions helper if the checkbox is checked (which is value 1, 0 if not)
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'  # flash.now is designed for flash messages on rendered pages - will disappear on first request
      render 'new'
    end
  end

  def destroy
    log_out if logged_in? # comes from sessions_helper.rb, only logs out if currently logged in
    redirect_to root_url
  end
end
