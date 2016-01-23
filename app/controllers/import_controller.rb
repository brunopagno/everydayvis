require 'csv'

class ImportController < ApplicationController
  
  def index
    #uploaded_io = params[:person][:picture]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
  end

  def upload
    uploaded_io = params[:file]
    
    #PRECISA PROCURAR NO BANCO DE DADOS?
    personame = 0

    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end

    puts "VOU PROCURAR OS ARQUIVOS"
    path = Rails.root.join('public','uploads','*.csv')
    Dir[path].each do |file_name|
      next if File.directory? file_name
      puts 'Importing: ' + file_name.split('/')[-1]

      person = Person.new

      relevant_stuff = false
      CSV.foreach(file_name) do |row|
        if relevant_stuff
          next unless row[0] and row[0] == ''
          dd = row[1].split('/')
          tt = row[2].split(':')
          puts "LINHA"
          puts $.
          print row
            if dd.length > 1
              datetime = Time.zone.local(dd[2].to_i, dd[1].to_i, dd[0].to_i,tt[0].to_i, tt[1].to_i, tt[2].to_i)
            else
              datetime = Time.at(row[1].to_i + row[2].to_i).to_datetime
            end

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
      puts "SALVEI"
      File.delete(Rails.root.join('public','uploads',uploaded_io.original_filename))
    end
  end
end