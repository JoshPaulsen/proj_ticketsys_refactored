class Note < ActiveRecord::Base
  # body:text
  # user_id:integer
  # ticket_id:integer
  # hidden:boolean
  
  belongs_to :user
  belongs_to :ticket
  
  validates :body, :presence => true
  
end
