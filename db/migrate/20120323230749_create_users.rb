class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :privilege
      t.string :password
      t.string :location

      t.timestamps
    end 
  end
end
