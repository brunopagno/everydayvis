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

  def clock_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    clock_data = {
      user_id: person.id,
      date: date,
      sunrise: person.sunrise_at(date),
      sunset: person.sunset_at(date)
    }

    clock_data[:activities] = person.activities_with_interval(date, 60) if person.has(:activities)
    clock_data[:luminosity] = person.luminosity_with_interval(date, 60) if person.has(:luminosities)
    clock_data[:works] = person.on_date_works(date) if person.has(:works)

    render json: clock_data
  end

  def histogram_day
    person = Person.find(params[:id])
    date = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i)

    render json: person.on_date(date)
  end

end
