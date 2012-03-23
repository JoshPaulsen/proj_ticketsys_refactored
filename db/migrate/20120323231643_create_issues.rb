class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :user_id
      t.integer :ticket_id

      t.timestamps
    end
  end
end
