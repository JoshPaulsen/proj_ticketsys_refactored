class Field < ActiveRecord::Base
  # form_id:integer
  # question:string
  # field_type:string
  # options:text
  # position:integer  
  
  serialize :options
  belongs_to :form, :class_name => "ServiceAreaForm"
  
  def render 
    
    if self.field_type == "text"
      render_text
    elsif self.field_type == "radio"  
      render_radio
    elsif self.field_type == "select"
      render_select
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
  
  def render_select    
    text =  ".form-field-select\n"
    text += "  = label :answers, :field_#{self.id}, '#{self.question}'\n"    
    text += "  = select :answers, :field_#{self.id}, ['one', 'two']\n"
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