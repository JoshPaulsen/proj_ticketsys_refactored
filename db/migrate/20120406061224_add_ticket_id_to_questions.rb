class AddTicketIdToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :ticket_id, :integer

  end
end
