class AddTokenToPeople < ActiveRecord::Migration
  def change
    add_column :people, :jawbone_token, :string
    add_column :people, :fitbit_token, :string
    add_column :people, :foursquare_token, :string
  end
end
