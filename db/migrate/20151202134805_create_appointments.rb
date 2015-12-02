class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :datetime
      t.text :description
      t.text :summary
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :appointments, :people
  end
end
