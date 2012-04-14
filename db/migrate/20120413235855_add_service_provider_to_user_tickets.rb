class AddServiceProviderToUserTickets < ActiveRecord::Migration
  def change
    add_column :user_tickets, :service_provider, :boolean

  end
end
