class UserTicket < ActiveRecord::Base
  # user_id:integer
  # ticket_id:integer
  
  belongs_to :user
  belongs_to :ticket
  
  scope :providers, where(:provider => true)
  scope :users, where(:provider => false)
end
