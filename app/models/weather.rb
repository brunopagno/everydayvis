class Weather < ActiveRecord::Base
  belongs_to :person

  scope :on_date, ->(date) { where(date: date.to_date).first }

end
