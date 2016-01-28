class CreateSmadas < ActiveRecord::Migration
  def change
    create_table :smadas do |t|

      t.timestamps null: false
    end
  end
end
