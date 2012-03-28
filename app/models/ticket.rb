class Ticket < ActiveRecord::Base  
  # title:string
  # description:text
  # location:string
  # creator_id:integer
  # provider_id:integer
  # opened_on:datetime
  # closed_on:datetime  
  
  belongs_to :creator, :class_name => "User"
  belongs_to :provider, :class_name => "User"
  has_many :issues
  has_many :users, :through => :issues, :uniq => true
  has_many :notes
  
  validates :title, :presence => true
  #validates :creator_id, :presence => true
  #validates :provider_id, :presence => true
  
  
  def set_creator(c)
    if !self.creator_id.nil?  
      remove_watcher_by_id(self.creator_id)
    end          
    self.creator_id = c.id
    if self.save
      add_watcher(c)
    else
      false
    end
  end
  
  def set_provider(p)
    if !self.provider_id.nil?
      remove_watcher_by_id(self.provider_id)
    end
    self.provider_id = p.id
    if self.save
      add_watcher(p)
    else
      false    
    end   
  end
  
  def add_watcher(w)
    issues.create!(:user => w) 
  end
  
  def add_watcher_by_id(wid)
    issues.create!(:user_id => wid) 
  end
  
  def remove_watcher(w)   
    remove_watcher_by_id(w.id)
  end
  
  def remove_watcher_by_id(wid)    
    issue = issues.find_by_user_id(wid)
    if issue.nil?
      false
    else
      issue.destroy   
      true
    end
  end
  
  def just_watchers
    watchers = self.users.where('user_id != ?', self.creator_id)
    watchers.where('user_id != ?', self.provider_id)    
  end
  
end
