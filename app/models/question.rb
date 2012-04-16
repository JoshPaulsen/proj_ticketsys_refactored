class Question < ActiveRecord::Base
  # ticket_id:integer
  # question:string  
  # answer:text
  
  belongs_to :ticket
end
