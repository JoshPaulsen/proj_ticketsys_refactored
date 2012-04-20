class RemoveLocationFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :location
  end
end
