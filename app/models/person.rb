class Person < ActiveRecord::Base

  has_many :activities

  def daily
    days = []

    date = activities.first.datetime
    date = Time.zone.local(date.year, date.month, date.day, 0, 0, 0)

    while (activities.last.datetime > date) do
      one_day = activities.where("datetime BETWEEN ? AND ?", date, date + 1.day - 1.second).order("datetime ASC")
      day = []
      day << { activity: 0, light: 0, datetime: one_day.first.datetime }
      one_day.each do |activity|
        if day.last[:datetime].hour != activity.datetime.hour
          day << { activity: 0, light: 0, datetime: activity.datetime }
          lasthour = activity.datetime.hour
        end
        day.last[:activity] += activity.activity
        day.last[:light] += activity.light
      end

      days << day
      date += 1.day;
    end

    return days
  end

  def at_hour(datetime)
    activities.where("datetime BETWEEN ? AND ?", datetime - 1.hour, datetime).order("datetime ASC")
  end

end
