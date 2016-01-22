class ImportController < ApplicationController

  def index
  	def upload
      uploaded_io = params[:file]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
  end
end
  end

end
