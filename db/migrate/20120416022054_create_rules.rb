class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.integer :provider_id
      t.integer :form_id
      t.integer :location_id

      t.timestamps
    end
  end
end
