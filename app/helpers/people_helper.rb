module PeopleHelper

  def daily_activities_to_json(user, daily)
    return {
      user_id: user.id,
      date: daily.first[:datetime].to_date,
      activities: daily.map{ |d| d[:activity] },
      luminosity: daily.map{ |d| d[:light] },
      sunrise: DateTime.new(2000, 1, 1, 5, 58, 0),
      sunset: DateTime.new(2000, 1, 1, 18, 29, 0)
    }.to_json
  end

end
