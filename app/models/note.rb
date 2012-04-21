class Note < ActiveRecord::Base
  # body:text
  # user_id:integer
  # ticket_id:integer
  # hidden:boolean
  attr_accessible :attachment, :body
  
  belongs_to :user
  belongs_to :ticket
  
  validates :body, :presence => true
  validates :user_id, :presence => true
  validates :ticket_id, :presence => true
  
  has_attached_file :attachment
  
end
