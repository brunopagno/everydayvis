class User < ActiveRecord::Base
  ActiveRecord::Base.establish_connection DBCONF

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable

  has_one :person, dependent: :destroy

end
