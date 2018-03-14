class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # debugger # this uses the 'byebug' gem 
  end

  def new
  end
end
