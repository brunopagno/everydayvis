class RemoveLightFromActivity < ActiveRecord::Migration
  def change
    remove_column :activities, :light
    remove_column :activities, :awake
  end
end
