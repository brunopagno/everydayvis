class LoginController < ApplicationController
  
  before_action :authenticate_user!

  def index
  	if current_user.nil?
  		redirect_to nouser_path
  	end
  end
end
