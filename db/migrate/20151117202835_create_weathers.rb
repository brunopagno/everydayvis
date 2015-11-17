class CreateWeathers < ActiveRecord::Migration
  def change
    create_table :weathers do |t|
      t.date :date
      t.integer :max_temperature
      t.integer :mean_temperature
      t.integer :min_temperature
      t.integer :precipitation
      t.string :events
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :weathers, :people
  end
end
