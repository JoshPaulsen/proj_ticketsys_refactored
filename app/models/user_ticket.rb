class UserTicket < ActiveRecord::Base
  # user_id:integer
  # ticket_id:integer
  # provider:boolean
  
  belongs_to :user
  belongs_to :ticket
  
  validates :user_id, :presence => true
  validates :ticket_id, :presence => true
  
  scope :providers, where(:provider => true)
  scope :users, where(:provider => false)
end
