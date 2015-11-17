class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.datetime :datetime
      t.string :name
      t.string :city
      t.string :country
      t.decimal :latitude
      t.decimal :longitude
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :locations, :people
  end
end
