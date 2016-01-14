class FitbitController < ApplicationController

  def index
  end

  def logged
  	@token = request.original_url
  end

end
