class RenameIssuesToUserTickets < ActiveRecord::Migration
  def change
    rename_table :issues, :user_tickets
  end
end
