class Field < ActiveRecord::Base
  # form_id:integer
  # question:string
  # field_type:string
  # options:text
  # position:integer  
  
  serialize :options
  belongs_to :form, :class_name => "ServiceAreaForm"
  
  def text?
    field_type == "text"
  end
  
  def radio?
    field_type == "radio"
  end
  
  def select?
    field_type == "select"
  end
  
  def check_box?
    field_type == "check box"
  end
  
  def render_options
    options = {}
    if self.select?
      key = "options_#{self.id}".to_sym
      options[key] = self.options
    end
    options
  end
  
  
  def render 
    type = self.field_type
    if type == "text"
      render_text
    elsif type == "radio"  
      render_radio
    elsif type == "select"
      render_select
    elsif type == "check box"
      render_check_box
    end
    
  end
  
  def render_text
    q = question.gsub("\"", "'")
    
    text =  ".form-field-text\n"
    text += "  = label :answers, :field_#{self.id}, \"#{q}\" \n"
    text += "  %br\n"
    text += "  = text_field :answers, :field_#{self.id}\n"
    text    
  end
  
  def render_radio
    q = question.gsub("\"", "'")
    text =  ".form-field-radio\n"
    text += "  = label :answers, :field_#{self.id}, \"#{q}\"\n"
    self.options.each do |option|
      option = option.gsub("\"", "'")
      text += ".form-field-radio-options\n"
      text += "  = radio_button :answers, :field_#{self.id}, \"#{option}\"\n"
      text += "  = label :answers, :field_#{self.id}, \"#{option}\"\n"
    end
    text
  end
  
  def render_select    
    q = question.gsub("\"", "'")
    text =  ".form-field-select\n"
    text += "  = label :answers, :field_#{self.id}, \"#{q}\"\n"    
    text += "  = select :answers, :field_#{self.id}, options_#{self.id}, :include_blank => true\n"
    text
  end
  
  def render_check_box
    q = question.gsub("\"", "'")
    text =  ".form-field-check-box\n"    
    text += "  = check_box :answers, :field_#{self.id}\n"
    text += "  = label :answers, :field_#{self.id}, \"#{q}\"\n"    
    text
  end
      
  def need_up?
    count = self.form.fields.count
    if count > 1
      if position == 1
        false
      else
        true
      end
    else
      false
    end
  end
  
  def need_down?
    count = self.form.fields.count
    if count > 1
      if position == count
        false
      else
        true
      end
    else
      false
    end
  end
  
  def engine
    Haml::Engine.new(render)
  end
  
end
