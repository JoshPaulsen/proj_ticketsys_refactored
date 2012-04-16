class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :ticket_id
      t.string :question
      t.text :answer

      t.timestamps
    end
    add_index :questions, :ticket_id
  end
end
