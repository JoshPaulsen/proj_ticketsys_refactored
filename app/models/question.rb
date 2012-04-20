class Question < ActiveRecord::Base
  # ticket_id:integer
  # question:string  
  # answer:text
  # position:integer
  
  
  
  belongs_to :ticket
end
