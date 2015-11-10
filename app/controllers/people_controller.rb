class PeopleController < ApplicationController

  def index
    @people = Person.all
  end

  def show
    @person = Person.find(params[:id])
  end

  def person_hour
    @person = Person.find(params[:id])
    datetime = Time.zone.local(params[:year].to_i, params[:month].to_i, params[:day].to_i, params[:hour].to_i, 0, 0)
    render json: @person.at_hour(datetime)
  end

end
