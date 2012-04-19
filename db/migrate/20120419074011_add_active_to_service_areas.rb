class AddActiveToServiceAreas < ActiveRecord::Migration
  def change
    add_column :service_areas, :active, :boolean

  end
end
