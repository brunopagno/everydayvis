class Person < ActiveRecord::Base

  belongs_to :user

  has_many :activities
  DAY_HOURS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  scope :with_user, -> { where("user_id IS NOT NULL") }

  def on_date(datetime)
    activities.where("datetime BETWEEN ? AND ?", datetime, datetime + 1.day - 1.second).order("datetime ASC")
  end

  def monthly
    days = []

    date = activities.first.datetime
    date = Time.zone.local(date.year, date.month, date.day, 0, 0, 0)

    while (activities.last.datetime > date) do
      day = { activity: 0, light: 0, datetime: date }

      self.on_date(date).each do |activity|
        day[:activity] += activity.activity
        day[:light] += activity.light
      end

      days << day
      date += 1.day;
    end

    return days
  end

  def daily
    days = []

    date = activities.first.datetime
    date = Time.zone.local(date.year, date.month, date.day, 0, 0, 0)

    while (activities.last.datetime > date) do
      one_day = self.on_date(date)
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

      hrs = day.map { |d| d[:datetime].hour }
      (DAY_HOURS - hrs).each do |hour|
        day.insert(hour - 1, { activity: 0,
                               light: 0,
                               datetime: Time.zone.local(date.year, date.month, date.day, hour, 0, 0) })
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
