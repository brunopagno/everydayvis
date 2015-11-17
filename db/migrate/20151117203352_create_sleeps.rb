class CreateSleeps < ActiveRecord::Migration
  def change
    create_table :sleeps do |t|
      t.date :date
      t.integer :sleep_time
      t.references :person, index: true

      t.timestamps null: false
    end
  end
end
