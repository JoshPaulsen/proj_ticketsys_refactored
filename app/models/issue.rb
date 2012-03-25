class Issue < ActiveRecord::Base
  # user_id:integer
  # ticket_id:integer
  
  belongs_to :user
  belongs_to :ticket  
  
end
