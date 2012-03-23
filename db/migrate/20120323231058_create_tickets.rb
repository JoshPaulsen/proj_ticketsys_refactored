class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :title
      t.text :description
      t.string :location
      t.datetime :opened_on
      t.datetime :closed_on
      t.integer :creator_id
      t.integer :provider_id

      t.timestamps
    end
  end
end
