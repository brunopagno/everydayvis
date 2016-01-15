class JawboneController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def code
  	uri = URI("https://jawbone.com/auth/oauth2/token?client_id=7NkRJA8m8sg&client_secret=59f2f3e8915b065113d9e54a76eda13672066004&grant_type=authorization_code&code=" + params[:code])
  	request = Net::HTTP::Get.new(uri.to_s, {})
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @response = http.request(request)

    jawjson = JSON.parse(@response.body)
    @teste =jawjson
    current_user.person.jawbone_token = jawjson["access_token"]
    current_user.person.save
  end

  def logged
  end

end
