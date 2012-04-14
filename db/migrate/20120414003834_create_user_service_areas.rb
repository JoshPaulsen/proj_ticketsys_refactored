class CreateUserServiceAreas < ActiveRecord::Migration
  def change
    create_table :user_service_areas do |t|
      t.integer :user_id
      t.integer :service_area_id

      t.timestamps
    end
    add_index :user_service_areas, :user_id
    add_index :user_service_areas, :service_area_id
  end
end
