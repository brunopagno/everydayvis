module PeopleHelper

  def daily_activities_to_json(user_id, daily)
    {
      user_id: user_id,
      date: daily.first.datetime,
    }
  end

end


  # var clock_data = {
  #   user_id: 1,
  #   date: new Date(2013, 4, 30),
  #   max_activity: 100,
  #   activities: [
  #     'sleep', 'sleep', 'sleep', 'sleep', 'sleep', 'sleep',
  #     21, 27, 20, 26, 23, 62, 65, 25, 35,
  #     28, 17, 31, 65, 88, 29, 25, 12, 'sleep'
  #   ],
  #   max_luminosity: 100,
  #   luminosity: [
  #     0, 0, 0, 0, 0, 0, 8, 18,
  #     11, 14, 11, 51, 54, 10, 13,
  #     44, 77, 13, 8, 16, 19, 10,
  #     11, 0
  #   ],
  #   sunrise: new Date(0, 0, 0, 5, 58),
  #   sunset: new Date(0, 0, 0, 18, 29)
  # }
