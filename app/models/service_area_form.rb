class ServiceAreaForm < ActiveRecord::Base
  # default_provider_id:integer
  # service_area_id:integer
  # title:string
  
  belongs_to :service_area
  belongs_to :default_provider, :class_name => "User"
  has_many :fields, :foreign_key => "form_id", :dependent => :destroy, :order => 'position ASC'
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
  
  def move_up(field)
    if field.position != 1
      other_field = fields.where(:position => field.position-1).first
      field.position -= 1
      other_field.position += 1
      field.save and other_field.save
    end    
  end
  
  def move_down(field)
    if field.position != fields.count
      other_field = fields.where(:position => field.position+1).first
      field.position += 1
      other_field.position -= 1
      field.save and other_field.save
    end
  end
  
  def update_field_order(del_pos)
    puts "here"
    puts del_pos
    update_fields = fields.where("position > ?", del_pos)
    puts "here--------------------------------------------"
    puts update_fields.count
    update_fields.each do |f|
      f.position -= 1
      f.save
    end
  end
  
end
