class ProblemsolverController < ApplicationController

  def index
    @people = Person.all
  end

  def busqueite
    client_secret = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1RFpaS1EiLCJhdWQiOiIyMjlaNzciLCJpc3MiOiJGaXRiaXQiLCJ0eXAiOiJhY2Nlc3NfdG9rZW4iLCJzY29wZXMiOiJyc29jIHJzZXQgcmFjdCBybG9jIHJ3ZWkgcmhyIHJudXQgcnBybyByc2xlIiwiZXhwIjoxNDg5MTQxNDkyLCJpYXQiOjE0ODY1NDk0OTJ9.uL2JsXp19ueLpvT-hwjvXZOdqVjNJld5TsBEKmDsH7M"

    path = "https://api.fitbit.com/1/user/-/activities/steps/2017-02-27/2017-03-01/1d.json"
    uri = URI.parse(path)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Authorization"] = "Bearer " + client_secret

    @response = http.request(request)
    @uri = uri
  end

end
