class AddProviderToUserTickets < ActiveRecord::Migration
  def change
    add_column :user_tickets, :provider, :boolean

  end
end
