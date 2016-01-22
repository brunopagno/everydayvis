class ImportController < ApplicationController

  def index
    @person = 0
    #uploaded_io = params[:person][:picture]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
  end

  def upload
    puts <params[:files]>
  end
end
