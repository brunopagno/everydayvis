class Person < ActiveRecord::Base
  ActiveRecord::Base.establish_connection DBCONF

  belongs_to :user

  has_many :activities, dependent: :destroy
  has_many :luminosities, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :weathers, dependent: :destroy
  has_many :daylights, dependent: :destroy
  has_many :works, dependent: :destroy
  has_many :appointments, dependent: :destroy

  DAY_HOURS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23]

  scope :with_user, -> { where("user_id IS NOT NULL") }
  scope :without_user, -> { where("user_id IS NULL") }

  def on_date(datetime)
    activities.where("datetime BETWEEN ? AND ?", datetime, datetime + 1.day - 1.second).order("datetime ASC")
  end

  def on_date_luminosity(datetime)
    luminosities.where("datetime BETWEEN ? AND ?", datetime, datetime + 1.day - 1.second).order("datetime ASC")
  end

  def on_date_works(datetime)
    works.where("start BETWEEN ? AND ?", datetime, datetime + 1.day - 1.second).order("start ASC")
  end

  def on_hour_appointments(datetime)
    appointments.where("datetime BETWEEN ? AND ?", datetime, datetime + 1.hour - 1.second)
  end

  def monthly
    days = []

    date = activities.first.datetime
    date = Time.zone.local(date.year, date.month, date.day, 0, 0, 0)

    ordered_activities = activities.order("datetime ASC")
    last_date = activities.last.datetime
    while (last_date > date) do
      ws = weathers.select{|w| w.date == date.to_date}
      ws = ws.first.events unless ws.empty?
      day = { activity: 0, weather: ws, work: 0, datetime: date }

      # optimizing number of queries here causes too much of a processing impact
      self.on_date(date).each do |activity|
        day[:activity] += activity.activity
      end
      self.on_date_works(date).each do |work|
        day[:work] += (work.finish - work.start) / 60
      end

      days << day
      date += 1.day;
    end

    return days
  end

  def at_hour(datetime)
    activities.where("datetime BETWEEN ? AND ?", datetime - 1.hour, datetime).order("datetime ASC")
  end

  def activities_with_interval(date, interval)
    day = []
    current = date.dup
    sum = 0
    on_date(date).map{|a| [a.datetime, a.activity]}.each do |activity|
      if activity[0] - current <= interval.minutes
        sum += activity[1]
      else
        while activity[0] - current > interval.minutes
          current += 1.hour
          day << { activity: sum, ev: (on_hour_appointments(current).count > 0) }
        end
        sum = activity[1]
      end
    end
    if sum > 0
      current += 1.hour
      day << { activity: sum, ev: (on_hour_appointments(current).count > 0) }
    end
    while day.count < 24
      day << { activity: 0, ev: false }
    end
    return day
  end

  def luminosity_with_interval(date, interval)
    day = []
    current = date.dup
    sum = 0
    itens = 0
    on_date_luminosity(date).map{|l| [l.datetime, l.light]}.each do |luminosity|
      if luminosity[0] - current <= interval.minutes
        sum += luminosity[1]
        itens += 1
      else
        while luminosity[0] - current > interval.minutes
          current += 1.hour
          day << sum / itens
        end
        sum = luminosity[1]
        itens = 1
      end
    end
    if sum > 0
      current += 1.hour
      day << sum / itens
    end
    while day.count < 24
      day << 0
    end
    return day
  end

  def sunrise_at(date)
    sunrise = daylights.where("sunrise BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).first
    return sunrise.sunrise if sunrise
    return DateTime.new(2015, 1, 1, 6, 12, 0)
  end

  def sunset_at(date)
    sunset = daylights.where("sunset BETWEEN ? AND ?", date.beginning_of_day, date.end_of_day).first
    return sunset.sunset if sunset
    return DateTime.new(2015, 1, 1, 19, 14, 0)
  end

  def has(attribute)
    !self.send(attribute).empty?
  end

  def map_data
    locations.map do |l|
      {
        date: l.datetime.to_date,
        lat: l.latitude,
        lng: l.longitude,
        activity: on_date(Time.zone.local(l.datetime.year, l.datetime.month, l.datetime.day, 0, 0, 0)).sum(:activity)
      }
    end
  end

end
