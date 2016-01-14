class FitbitController < ApplicationController

  def index
  end

  def logged
  	@token = params[:access_token]
  end

  def teste
  end

end
