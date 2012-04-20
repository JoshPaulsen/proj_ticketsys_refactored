class Ticket < ActiveRecord::Base  
  # title:string
  # description:text
  # location:string  
  # creator_id:integer
  # provider_id:integer
  # service_area_id:integer
  # opened_on:datetime
  # closed_on:datetime  
  
  belongs_to :creator, :class_name => "User"
  belongs_to :provider, :class_name => "User"
  belongs_to :service_area
  has_many :user_tickets, :dependent => :destroy
  has_many :users, :through => :user_tickets, :uniq => true
  has_many :notes, :dependent => :destroy 
  has_many :questions, :dependent => :destroy
  
  validates :title, :presence => true
  validates :opened_on, :presence => true  
  validates :service_area_id, :presence => true
  
  def closed?
    !closed_on.blank?
  end
  
  def open?
    closed_on.blank?
  end
  
  # Removed check for valid save in setters.
  
  def set_creator(c)
    if self.creator_id  
      remove_user_by_id(self.creator_id)
    end          
    self.creator_id = c.id
    if self.save
      add_additional_user(c) 
      true
    else
      false
    end   
  end
  
  def set_provider(p)
    set_provider_by_id p.id
    #if self.provider_id
    #  remove_user_by_id(self.provider_id)
    #end
    #self.provider_id = p.id
    #self.save
    #add_additional_provider(p)
  end
  
  def set_provider_by_id(prov_id)
    if self.provider_id
      remove_user_by_id(self.provider_id)
    end
    # look at this again....
    user_tickets.where(:user_id => prov_id).each do |u_t|
      u_t.destroy
    end
    
    self.provider_id = prov_id
    self.save
    add_additional_provider_by_id(prov_id)
  end
  
  
  def remove_user(user)
    remove_user_by_id user.id
  end
  
  def remove_user_by_id(user_id)
    user = user_tickets.find_by_user_id(user_id)
    if user
      user.destroy   
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
  
  def add_additional_provider(provider)
    user_tickets.create!(:user => provider, :provider => true)
  end
  
  def add_additional_provider_by_id(provider_id)
    user_tickets.create!(:user_id => provider_id, :provider => true)
  end
  
  def additional_users
    add_users = self.user_tickets.users.where('user_id != ?', self.creator_id).collect do |u|     
      u.user     
    end
  end
  
  def additional_providers
    if self.provider_id
      add_users = self.user_tickets.providers.where('user_id != ?', self.provider_id).collect do |u|     
        u.user
      end
    else
      add_users = self.user_tickets.providers.collect do |u|
        u.user
      end
    end
  end
  
   def add_answers(answers)
    if !answers.blank?
      answers.each do |field, answer|      
        field_id = field.delete("field_").to_i        
        field = Field.find_by_id field_id
        if field.field_type == "check box"
          if answer == "1"
            answer = "Yes"
          else
            answer = "No"
          end
        end        
        questions.create :question => field.question, :answer => answer
      end
      self.save
    end
  end
  
end
