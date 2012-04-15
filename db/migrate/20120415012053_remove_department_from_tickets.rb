class RemoveDepartmentFromTickets < ActiveRecord::Migration
  def change
    remove_column :tickets, :department
  end
end
