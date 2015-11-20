class PeopleController < ApplicationController

  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def person_hour
    person = Person.find(params[:id])
    datetime = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, 0, 0)
    render json: person.at_hour(datetime)
  end

  def clock_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    clock_data = {
      user_id: person.id,
      date: date,
      activities: person.activities_with_interval(date, 60),
      luminosity: person.luminosity_with_interval(date, 60),
      sunrise: person.sunrise_at(date),
      sunset: person.sunset_at(date)
    }

    render json: clock_data
  end

end
