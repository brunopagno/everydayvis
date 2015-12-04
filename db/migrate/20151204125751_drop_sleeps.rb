class DropSleeps < ActiveRecord::Migration
  def change
    drop_table :sleeps
  end
end
