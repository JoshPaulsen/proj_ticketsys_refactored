class CreateServiceAreaForms < ActiveRecord::Migration
  def change
    create_table :service_area_forms do |t|
      t.integer :default_provider_id
      t.integer :service_area_id
      t.string :title

      t.timestamps
    end
  end
end
