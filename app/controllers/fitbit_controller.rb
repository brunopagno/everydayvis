class FitbitController < ApplicationController

  def index
  end

  def logged
  	@token = params[:access_token]
  end

  def teste
  	@token = params[:access_token]
  end

end
