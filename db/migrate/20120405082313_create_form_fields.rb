class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :form_fields do |t|
      t.string :description
      t.string :field_type
      t.integer :ticket_form_id
      t.text :options

      t.timestamps
    end
  end
end
