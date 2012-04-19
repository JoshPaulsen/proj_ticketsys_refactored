class AddActiveToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :active, :boolean

  end
end
