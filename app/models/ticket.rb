class Ticket < ActiveRecord::Base  
  # title:string
  # description:text
  # location:string
  # department:string
  # creator_id:integer
  # provider_id:integer
  # opened_on:datetime
  # closed_on:datetime  
  
  belongs_to :creator, :class_name => "User"
  belongs_to :provider, :class_name => "User"
  has_many :user_tickets
  has_many :users, :through => :user_tickets, :uniq => true
  has_many :notes
  
  # Is there anything else a ticket must have?  Department?
  # Requiring a creator and a provider could be tricky if we allow
  # Users to be deleted.
  validates :title, :presence => true
  validates :opened_on, :presence => true
  
  def closed?
    !closed_on.blank?
  end
  
  def open?
    closed_on.blank?
  end
  
  # Removed check for valid save in setters.
  
  def set_creator(c)
    if self.creator_id  
      remove_watcher_by_id(self.creator_id)
    end          
    self.creator_id = c.id
    self.save
    add_watcher(c)    
  end
  
  def set_provider(p)
    if self.provider_id
      remove_watcher_by_id(self.provider_id)
    end
    self.provider_id = p.id
    self.save
    add_watcher(p)
  end
  
  def add_watcher(w)
    user_tickets.create!(:user => w) 
  end
  
  def add_watcher_by_id(wid)
    user_tickets.create!(:user_id => wid) 
  end
  
  def remove_watcher(w)   
    remove_watcher_by_id(w.id)
  end
  
  def remove_watcher_by_id(wid)    
    users = user_tickets.find_by_user_id(wid)
    if users
      users.destroy   
      true      
    else
      false
    end
  end
  
  def add_additional_user(user)
    user_tickets.create!(:user => user, :provider => false)
  end
  
  def add_additional_user_by_id(user_id)
    user_tickets.create!(:user_id => user_id, :provider => false)
  end
  
  
  def just_watchers
    watchers = self.users.where('user_id != ?', self.creator_id)
    watchers.where('user_id != ?', self.provider_id)    
  end
  
end
