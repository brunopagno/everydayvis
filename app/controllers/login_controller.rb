class LoginController < ApplicationController


  def index
  	if @current_user.nil?
  		redirect_to nouser
  	end
  end
