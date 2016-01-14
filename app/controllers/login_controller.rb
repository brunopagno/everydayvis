class LoginController < ApplicationController

unless @current_user.nil?
  def index
  end

else
	def nouser
	end
end


end
