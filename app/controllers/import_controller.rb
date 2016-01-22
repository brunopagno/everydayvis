class ImportController < ApplicationController

  def index
    @person = 0
    #uploaded_io = params[:person][:picture]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
  end

  def upload
   files = params[:files]


    person = Person.new

    relevant_stuff = false
    CSV.foreach(files) do |row|
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
