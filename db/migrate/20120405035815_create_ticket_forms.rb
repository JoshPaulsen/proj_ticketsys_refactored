class CreateTicketForms < ActiveRecord::Migration
  def change
    create_table :ticket_forms do |t|
      t.string :department
      t.string :name

      t.timestamps
    end
  end
end
