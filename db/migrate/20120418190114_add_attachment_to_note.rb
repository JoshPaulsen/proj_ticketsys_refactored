class AddAttachmentToNote < ActiveRecord::Migration
  def change
    add_column :notes, :attachment_file_name,    :string
    add_column :notes, :attachment_content_type, :string
    add_column :notes, :attachment_file_size,    :integer
    add_column :notes, :attachment_updated_at,   :datetime
  end
end
