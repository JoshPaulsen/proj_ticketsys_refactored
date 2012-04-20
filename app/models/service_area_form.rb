class ServiceAreaForm < ActiveRecord::Base
  # default_provider_id:integer
  # service_area_id:integer
  # title:string
  
  belongs_to :service_area
  belongs_to :default_provider, :class_name => "User"
  has_many :fields, :foreign_key => "form_id", :dependent => :destroy, :order => 'position ASC'
  has_many :rules, :foreign_key => "form_id", :dependent => :destroy, :uniq => true
  
  
  class HHelper
    include Singleton
    include ActionView::Helpers::FormHelper
    #include ActionView::Helpers::UrlHelper
    #include ActionView::Helpers::TagHelper
    #include ActionView::Helpers::FormTagHelper
    #include ActionView::Helpers::AssetTagHelper
    #include ActionView::Helpers::FormOptionsHelper
  end
  
  def get_helper
    HHelper.instance
  end
  
  def get_form_engine
    all_fields = ""    
    if !fields.empty?
      fields.each do |f|
        all_fields += f.render
      end
    end
    Haml::Engine.new(all_fields)
  end
  
  def get_all
    all_fields = ""    
    if !fields.empty?
      fields.each do |f|
        all_fields += f.render
      end
    end
   all_fields
  end
  
  def get_select_options
    options = {}
    fields.each do |f|
      if f.select?
        key = "options_#{f.id}".to_sym
        options[key] = f.options
      end
    end
    options
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
    update_fields = fields.where("position > ?", del_pos)
    update_fields.each do |f|
      f.position -= 1
      f.save
    end
  end
  
end
