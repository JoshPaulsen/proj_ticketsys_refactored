class AddPositionToFields < ActiveRecord::Migration
  def change
    add_column :fields, :position, :integer

  end
end
