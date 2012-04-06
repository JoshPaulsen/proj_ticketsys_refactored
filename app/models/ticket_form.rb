class TicketForm < ActiveRecord::Base
  
  has_many :form_fields
  
  def write_form
    
    fields = ""    
    if !form_fields.empty?
      form_fields.each do |f|
        fields += render_field f
      end      
    else
      return false
    end
    
    write_form_to_file fields
    
  end
  
  private
  
  def forms_directory 
    "app/views/ticket_forms/area_ticket_forms/"
  end
  
  def form_name
    "_ticket_form_#{self.id}.html.haml"
  end
  
  def write_form_to_file(form)
    write_out = File.new(forms_directory + form_name, "w")
    bytes = write_out.write(form)
    write_out.close    
    bytes != 0
  end
  
  def render_field(field)
    
    if field.field_type == "text"
      render_text(field)
    elsif field.field_type == "radio"
      render_radio(field)
    end
    
    
  end
  
  def render_text(field)
    text =  ".form-field-text\n"
    text += "  = label :answers, :field_#{field.id}, '#{field.description}'\n"
    text += "  %br\n"
    text += "  = text_field :answers, :field_#{field.id}\n"
    text    
  end
  
  def render_radio(field)
    i = 0
    text =  ".form-field-radio\n"
    text += "  = label :answers, :field_#{field.id}, '#{field.description}'\n"
    field.options.each do |option|
      text += "  = radio_button :answers, :field_#{field.id}_option_#{i}\n"
      text += "  = label :answers, :field_#{field.id}_option_#{i}, '#{option}'\n"
      i += 1
    end
   
    text
  end
  
  
end
