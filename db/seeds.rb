require 'csv'

Dir['quidata/*.csv'].each do |file_name|
  next if File.directory? file_name
  puts 'reading: ' + file_name.split('/')[-1]
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

      # create model here
    end

    relevant_stuff = true if row.join(',').start_with? "Line,Date,Time,Activity,Marker,White Light,Sleep/Wake,Interval Status"
  end
end

# Models~~
# 
# Person/Subject/Patient/User
#   code:string, identity:string, name:string, gender:string, age:integer
# 
# Activity
#   datetime:datetime, activity:integer, light:float, awake:boolean, person:references