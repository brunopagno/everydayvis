class ImportController < ApplicationController

  def index
    uploaded_io = params[:file][:picture]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
  end
end
