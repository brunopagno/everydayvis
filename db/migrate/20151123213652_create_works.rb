class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :name
      t.datetime :start
      t.datetime :finish
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :works, :people
  end
end
