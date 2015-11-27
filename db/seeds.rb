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

        datetime = Time.zone.local(dd[2].to_i, dd[1].to_i, dd[0].to_i,
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
      d = Time.zone.local(dd[0..3].to_i, dd[4..5].to_i, dd[6..7].to_i, dd[8..9].to_i, 0, 0)

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
    rise = Time.zone.local(year, month, day, d[0].to_i, d[1].to_i, 0)

    d = row['set'].split(':')
    set = Time.zone.local(year, month, day, d[0].to_i, d[1].to_i, 0)

    Daylight.create!(
        person:  person,
        sunrise: rise,
        sunset:  set,
      )

    day += 1
  end

  # THE WORKTASKS ARE HAPPENING INSIDE HERE

  # THE WORKTASKS END HERE
end

cd = Date.today
CSV.foreach('db/data/work.csv', headers: false) do |row|
  z = row[0]

  if z.nil? or z.start_with?("Total") or z.start_with?("TOTAL") or z.start_with?("[") or z.start_with?("Nenhuma")
    next
  end

  if z.start_with?("DOM") or
     z.start_with?("SEG") or
     z.start_with?("TER") or
     z.start_with?("QUA") or
     z.start_with?("QUI") or
     z.start_with?("SEX") or
     z.start_with?("SÁB")
    dd = z.split(',')[1]
    dd = dd.split('DE')
    case dd[1].strip
      when "JANEIRO"
        dd[1] = 1
      when "FEVEREIRO"
        dd[1] = 2
      when "MARÇO"
        dd[1] = 3
      when "ABRIL"
        dd[1] = 4
      when "MAIO"
        dd[1] = 5
      when "JUNHO"
        dd[1] = 6
      when "JULHO"
        dd[1] = 7
      when "AGOSTO"
        dd[1] = 8
      when "SETEMBRO"
        dd[1] = 9
      when "OUTUBRO"
        dd[1] = 10
      when "NOVEMBRO"
        dd[1] = 11
      when "DEZEMBRO"
        dd[1] = 12
      end
    cd = Date.new(2015, dd[1], dd[0].to_i)
  elsif !z.nil?
    hhmm = row[1].split(':')
    start = Time.zone.local(cd.year, cd.month, cd.day, hhmm[0].to_i, hhmm[1].to_i, 00)
    hhmm = row[2].split(':')
    finish = Time.zone.local(cd.year, cd.month, cd.day, hhmm[0].to_i, hhmm[1].to_i, 00)

    if finish.hour < start.hour
      finish += 1.day
    end

    Work.create!(
      person: person,
      name:   row[0],
      start:  start,
      finish: finish
    )
  end
end
