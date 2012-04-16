class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.integer :form_id
      t.string :question
      t.string :field_type
      t.text :options

      t.timestamps
    end
    add_index :fields, :form_id
  end
end
