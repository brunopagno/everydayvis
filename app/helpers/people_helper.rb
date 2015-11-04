module PeopleHelper

  def daily_activities_to_json(user, daily)
    return {
      user_id: user.id,
      date: daily.first[:datetime],
      activities: daily.map{ |d| d[:activity] },
      luminosity: daily.map{ |d| d[:light] },
      sunrise: DateTime.new(2000, 1, 1, 6, 58, 0),
      sunset: DateTime.new(2000, 1, 1, 19, 29, 0)
    }.to_json
  end

end