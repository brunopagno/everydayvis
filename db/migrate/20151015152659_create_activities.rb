class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.datetime :datetime
      t.integer :activity
      t.float :light
      t.boolean :awake
      t.references :person, index: true

      t.timestamps null: false
    end
    add_foreign_key :activities, :people
  end
end
