class Activity < ActiveRecord::Base
  ActiveRecord::Base.establish_connection DBCONF

  belongs_to :person

end
