require 'csv'

if Person.all.empty?
  personame = 1
  Dir['quidata/*.csv'].each do |file_name|
    next if File.directory? file_name
    puts 'Importing: ' + file_name.split('/')[-1]

    person = Person.new

    relevant_stuff = false
    CSV.foreach(file_name) do |row|
      if relevant_stuff
        next unless row[0]
        dd = row[1].split('/')
        tt = row[2].split(':')

        datetime = DateTime.new(dd[2].to_i, dd[1].to_i, dd[0].to_i,
                                tt[0].to_i, tt[1].to_i, tt[2].to_i)
        activity = row[3].to_i
        light = row[5].to_f

        Activity.create!({
          person: person,
          datetime: datetime,
          activity: activity,
        })
        Luminosity.create!({
          person: person,
          datetime: datetime,
          light: light,
        })
      elsif row.join(',').start_with? "Code"
        person.code = row[1]
      elsif row.join(',').start_with? "Identity"
        person.identity = row[1]
      elsif row.join(',').start_with? "Initials"
        person.name = row[1]
      elsif row.join(',').start_with?("Full Name") && row[1] != "Not Entered"
        person.name = row[1]
      elsif row.join(',').start_with? "Age (at start of data collection)"
        person.age = row[1].to_i
      elsif !person.name || person.name.empty?
        person.name = "person_" + personame.to_s
        personame += 1;
      end

      relevant_stuff = true if !relevant_stuff and row.join(',').start_with? "Line,Date,Time,Activity,Marker,White Light,Sleep/Wake,Interval Status"
    end

    person.save!
  end
end

nedel = User.find_by_email('lunedel@gmail.com')
if !nedel
  nedel = User.create!(email: 'lunedel@gmail.com', password: '12341234')

  person = Person.create(
    user: nedel,
    name: 'Luciana'
  )

  # load data
  CSV.foreach('db/data/weather.csv', headers: true) do |row|
    d = row['BRST'].split('-')
    Weather.create!(
        person:           person,
        date:             Date.new(d[0].to_i, d[1].to_i, d[2].to_i),
        max_temperature:  row['max_temp'],
        mean_temperature: row['mean_temp'],
        min_temperature:  row['min_temp'],
        precipitation:    row['precipitation'],
        events:           row['events']
      )
  end

  CSV.foreach('db/data/jawbone.csv', headers: true) do |row|
    d = row['DATE']
    dd = Date.new(d[0..3].to_i, d[4..5].to_i, d[6..7].to_i)

    Sleep.create!(
        person:     person,
        date:       dd,
        sleep_time: row['s_asleep_time'],
      )
  end

  checkins = JSON(open('db/data/checkins.json').read)
  checkins['response']['checkins']['items'].each do |item|
    d = DateTime.strptime(item['createdAt'].to_s, '%s')
    Location.create!(
        person:    person,
        datetime:  d,
        name:      item['venue']['name'],
        city:      item['venue']['location']['city'],
        country:   item['venue']['location']['country'],
        latitude:  item['venue']['location']['lat'],
        longitude: item['venue']['location']['lng']
      )
  end

  timesteps = JSON(open('db/data/timesteps.json').read)
  timesteps['data']['items'].each do |item|
    item['details']['hourly_totals'].each do |hourly|
      dd = hourly[0] #key
      d = DateTime.new(dd[0..3].to_i, dd[4..5].to_i, dd[6..7].to_i, dd[8..9].to_i, 0, 0)

      Activity.create!({
          person: person,
          datetime: d,
          activity: hourly[1]['steps'],
        })
    end
  end

  day = 1
  month = 3
  year = 2015
  CSV.foreach('db/data/sunrise_sunset_poa_march2015.csv', headers: true) do |row|
    d = row['rise'].split(':')
    rise = DateTime.new(year, month, day, d[0].to_i, d[1].to_i, 0)

    d = row['set'].split(':')
    set = DateTime.new(year, month, day, d[0].to_i, d[1].to_i, 0)

    Daylight.create!(
        person:  person,
        sunrise: rise,
        sunset:  set,
      )

    day += 1
  end
end
