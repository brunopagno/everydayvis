class WeatherController < ApplicationController

  # the URL => weather/:year/:month/:day/:latitude/:longitude
  def show
    year = params[:year].to_i
    month = params[:month].to_i
    day = params[:day].to_i

    latitude = params[:latitude]
    latitude = params[:longitude]

    date = Date.new(year, month, day)

    # do stuff here

    # the format of the thingy you have to return is something like this
    # you can customize the parameters, here, I only gave some idea of what to show
    # the date parameter is useful, so do not remove even if it seems useless
    the_one_dictionary_with_all_the_info = {
      temperature: 25,
      condition: 'sunny',
      precipitation: 0,
      date: date
    }

    # return the weather info
    render json: the_one_dictionary_with_all_the_info
  end

end
