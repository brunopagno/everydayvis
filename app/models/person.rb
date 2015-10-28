class Person < ActiveRecord::Base

  has_many :activities

  def daily(date = nil)
    date = activities.first.datetime unless date
    date = DateTime.new(date.year, date.month, date.day, -3, 0, 0)

    activities.where("datetime BETWEEN ? AND ?", date, date + 1.day)
  end

  def at_hour(datetime)
    acts = activities.where("datetime BETWEEN ? AND ?", datetime, datetime + 1.hour)
  end

end
