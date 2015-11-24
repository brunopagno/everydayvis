class CreateDaylights < ActiveRecord::Migration
  def change
    create_table :daylights do |t|
      t.datetime :sunrise
      t.datetime :sunset
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :daylights, :people
  end
end
