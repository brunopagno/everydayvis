class PagesController < ApplicationController

  def index
  end

  def person_hour
    @person = Person.find(params[:id])
    date = DateTime.new(params[:year], params[:month], params[:day], params[:hour], 0, 0)

    respond_to do |format|
      format.json {
        render json: @person.at_hour(datetime)
      }
    end
  end

end
