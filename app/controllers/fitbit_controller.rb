class FitbitController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def logged
  end

  def token
  	token = params[:token]
    current_user.person.fitbit_token = token
    current_user.person.save
  end

end
