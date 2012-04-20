class AddLocationIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :location_id, :integer

  end
end
