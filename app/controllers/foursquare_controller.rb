class FoursquareController < ApplicationController

  def index
  end

  def code
  	uri = URI("https://foursquare.com/oauth2/access_token?client_id=DXNTVHRHFKEM2RUW5RPP1WL40AWM2OWZADS53LA1BPAATHNR&client_secret=CIN4INFRTBVUVIKHENWOKLOR4VKYKMUDOGXKTXNVCIHTO0TP&grant_type=authorization_code&redirect_uri=http://nedel.cloudapp.net/foursquarecode&code=" + params[:code])
  	request = Net::HTTP::Get.new(uri.to_s, {})
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    @response = http.request(request)
  end

  def logged
  end

end
