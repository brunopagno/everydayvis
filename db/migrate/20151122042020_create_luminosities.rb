class CreateLuminosities < ActiveRecord::Migration
  def change
    create_table :luminosities do |t|
      t.datetime :datetime
      t.float :light
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :luminosities, :people
  end
end
