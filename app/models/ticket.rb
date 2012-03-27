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
  validates :creator_id, :presence => true
  
  
  def add_creator(c)
    if update_attributes! :creator_id => c.id
      issues.create!(:user => c)    
    end
    #creator = c
    
     
  end
  
  def add_provider(p)
    #update_attributes! :provider => p
    #provider = p
    #save
    #issues.create!(:user => p)  
    
    if update_attributes! :provider => p
      #issues.create!(:user => p, :ticket => self)    
      issues.create!(:user => p)      
    end   
  end
  
end
