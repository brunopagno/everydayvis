require 'csv'

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
      awake = row[7] == 'ACTIVE'

      Activity.create!({
        person: person,
        datetime: datetime,
        activity: activity,
        light: light,
        awake: awake
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
    end

    relevant_stuff = true if !relevant_stuff and row.join(',').start_with? "Line,Date,Time,Activity,Marker,White Light,Sleep/Wake,Interval Status"
  end

  person.save!
end

# Models~~
# 
# Person/Subject/Patient/User
#   code:string, identity:string, name:string, gender:string, age:integer
# 
# Activity
#   datetime:datetime, activity:integer, light:float, awake:boolean, person:references