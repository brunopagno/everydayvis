class ImportController < ApplicationController

  def index
    if 'person' in params:
        uploaded_io = params[:person][:picture]
        File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
        file.write(uploaded_io.read)
    end
  end
end
