module TicketFormsHelper
  
  def get_form_names_for(department)
    
    forms = TicketForm.find_by_department(department)
    form_names = []
    if forms    
      forms.each do |f|      
        form_names << f.name      
      end
    end
    
    form_names
    
  end
end
