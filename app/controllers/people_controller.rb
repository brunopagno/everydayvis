class PeopleController < ApplicationController
  decorates_assigned :person

  def index
    @people = Person.all.decorate
  end

  def show
    @person = Person.find(params[:id])
  end

  def person_hour
    person = Person.find(params[:id])
    datetime = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, 0, 0)
    render json: person.at_hour(datetime)
  end

  def max_activity
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    max_activity = person.on_date(date).map(&:activity).max

    render json: max_activity
  end

  def clock_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    clock_data = {
      user_id: person.id,
      date: date,
      sunrise: person.sunrise_at(date),
      sunset: person.sunset_at(date),
      max_activity: person.activities.map(&:activity).max
    }

    clock_data[:activities]   = person.activities_with_interval(date, 60) if person.has(:activities)
    clock_data[:luminosity]   = person.luminosity_with_interval(date, 60) if person.has(:luminosities)
    clock_data[:works]        = person.on_date_works(date)                if person.has(:works)
    clock_data[:weather]      = person.weathers.select{|w| w.date == date.to_date}.first if person.has(:weathers)

    render json: clock_data
  end

  def histogram_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    render json: person.on_date(date)
  end

  def luminosity_histogram_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    render json: person.on_date_luminosity(date)
  end

end
