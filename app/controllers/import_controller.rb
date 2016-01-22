class ImportController < ApplicationController
  @@files = 0
  def index
    @@files = 0
    #uploaded_io = params[:person][:picture]
    #File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    #file.write(uploaded_io.read)
    #end
  end

  def upload
    @@files = params[:files]

  end
end
