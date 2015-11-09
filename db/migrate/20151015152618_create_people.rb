class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :code
      t.string :identity
      t.string :name
      t.string :gender
      t.integer :age

      t.timestamps null: false
    end
  end
end
