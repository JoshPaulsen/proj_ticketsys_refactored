class Field < ActiveRecord::Base
  # form_id:integer
  # question:string
  # field_type:string
  # options:text
  serialize :options
  belongs_to :form, :class_name => "ServiceAreaForm"  
  
  def render 
    
    if self.field_type == "text"
      render_text
    elsif self.field_type == "radio"  
      render_radio
    end
    
  end
  
  def render_text
    text =  ".form-field-text\n"
    text += "  = label :answers, :field_#{self.id}, '#{self.question}'\n"
    text += "  %br\n"
    text += "  = text_field :answers, :field_#{self.id}\n"
    text    
  end
  
  def render_radio    
    text =  ".form-field-radio\n"
    text += "  = label :answers, :field_#{self.id}, '#{self.question}'\n"
    self.options.each do |option|
      text += ".form-field-radio-options\n"
      text += "  = radio_button :answers, :field_#{self.id}, '#{option}'\n"
      text += "  = label :answers, :field_#{self.id}, '#{option}'\n"
    end
    text
  end
  
end
