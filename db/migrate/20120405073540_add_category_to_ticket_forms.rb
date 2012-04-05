class AddCategoryToTicketForms < ActiveRecord::Migration
  def change
    add_column :ticket_forms, :category, :string

  end
end
