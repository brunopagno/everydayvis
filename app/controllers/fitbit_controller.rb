class FitbitController < ApplicationController

  def index
  end

  def logged
  end

  def token
  	@token = params[:token]
  end

end
