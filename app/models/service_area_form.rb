class ServiceAreaForm < ActiveRecord::Base
  # default_provider_id:integer
  # service_area_id:integer
  # title:string
  
  belongs_to :service_area
  belongs_to :default_provider, :class_name => "User"
  has_many :fields, :foreign_key => "form_id", :dependent => :destroy  
  has_many :rules, :foreign_key => "form_id", :dependent => :destroy, :uniq => true
  
  def get_form_engine
    all_fields = ""    
    if !fields.empty?
      fields.each do |f|
        all_fields += f.render
      end
    end
    Haml::Engine.new(all_fields)
  end
  
end
