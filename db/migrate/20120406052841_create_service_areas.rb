class CreateServiceAreas < ActiveRecord::Migration
  def change
    create_table :service_areas do |t|
      t.string :name

      t.timestamps
    end
  end
end
