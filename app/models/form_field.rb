class FormField < ActiveRecord::Base
  
  serialize :options
  belongs_to :ticket_form 
  
end
