class ServiceAreaForm < ActiveRecord::Base
  # default_provider_id:integer
  # service_area_id:integer
  # title:string
  
  belongs_to :service_area
  belongs_to :default_provider, :class_name => "User"
  has_many :fields, :foreign_key => "form_id", :dependent => :destroy  
  has_many :rules, :foreign_key => "form_id", :dependent => :destroy, :uniq => true
  
  def write_form
    all_fields = ""    
    if !fields.empty?
      fields.each do |f|
        all_fields += f.render
      end
    end
    write_form_to_file all_fields
  end
  
  def delete_file
    if File.exist?(form_name_path)
      File.delete(form_name_path)
    end
  end
  
  def forms_directory 
    "app/views/service_area_forms/area_forms/"
  end
  
  def form_name
    "_ticket_form_#{self.id}.html.haml"
  end
  
  def form_name_path
    forms_directory + form_name
  end
  
  def write_form_to_file(form)
    if file_exist?
      delete_file
    end
    write_out = File.new(form_name_path, "w")
    write_out.write(form)
    write_out.close    
    file_exist?
  end  
  
  def file_exist?
    File.exist?(form_name_path)
  end
  
end
