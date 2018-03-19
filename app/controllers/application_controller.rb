class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper        # makes the sessions helper available in all controllers
end
