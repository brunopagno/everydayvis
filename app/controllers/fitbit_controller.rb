class FitbitController < ApplicationController

  def index
  end

  def logged
  	@token = params[:token]
  end

  def token
  	@token = params[:token]
  end

end
