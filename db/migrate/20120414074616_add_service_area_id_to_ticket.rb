class AddServiceAreaIdToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :service_area_id, :integer
    add_index :tickets, :service_area_id
  end
end
