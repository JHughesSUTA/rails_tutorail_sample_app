class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      # remembers the logged-in user from sessions helper if the checkbox is checked (which is value 1, 0 if not)
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_to @user      # same as 'user_url(user)'
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
