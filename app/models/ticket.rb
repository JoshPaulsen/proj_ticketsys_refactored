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
  validates :provider_id, :presence => true
  
  
  def add_creator(c)
    self.creator_id = c.id
    if self.save
      issues.create!(:user => c) 
    else
      false
    end
  end
  
  def add_provider(p)
    #self.provider_id = p.id
    #issues.create!(:user => p)
    #update_attributes! :provider => p
    #provider = p
    #save
    #issues.create!(:user => p)  
    self.provider_id = p.id
    if self.save
      #issues.create!(:user => p, :ticket => self)    
      puts "WORKED"
      issues.create!(:user => p)  
    else
      puts "WHAT THE FUCK"
      false    
    end   
  end
  
end
