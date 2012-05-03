class Note < ActiveRecord::Base
  # body:text
  # user_id:integer
  # ticket_id:integer
  # hidden:boolean
  
  default_scope :order => 'created_at DESC'
  
  belongs_to :user
  belongs_to :ticket
  
  validates :body, :presence => true
  validates :user_id, :presence => true
  validates :ticket_id, :presence => true
  
  has_attached_file :attachment
  
  def made_by
    if user.admin?
      "admin"
    elsif user.provider?
      "provider"
    else
      "user"
    end
  end
  
end
