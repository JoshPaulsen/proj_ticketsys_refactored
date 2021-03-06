class Ticket < ActiveRecord::Base  
  # title:string
  # description:text
  # location_id:integer  
  # creator_id:integer
  # provider_id:integer
  # service_area_id:integer
  # opened_on:datetime
  # closed_on:datetime  
  default_scope :order => 'created_at ASC'
  #scope :closed, where("closed_on != ?", "NULL")
  scope :closed, where("closed_on IS NOT NULL")
  scope :opened, where(:closed_on => nil)
  #scope :search_all, where("id != ?", "NULL")
  scope :search_all, where("id IS NOT NULL")
  scope :for_service_areas, lambda {|sa_list| where(:service_area_id => sa_list)}
  scope :for_user, lambda {|user| joins(:user_tickets).where("user_tickets.user_id = ?", user)}
  #scope :test, lambda { joins(:user_tickets).where("user_tickets.user_id = ?", 5)}
  #scope :acc, lambda {|list, user| for_service_areas(list).for_user(user)}
  
  
  belongs_to :creator, :class_name => "User"
  belongs_to :provider, :class_name => "User"
  belongs_to :service_area
  belongs_to :location
  has_many :user_tickets, :dependent => :destroy
  has_many :users, :through => :user_tickets, :uniq => true
  has_many :notes, :dependent => :destroy, :order => 'created_at DESC'
  has_many :questions, :dependent => :destroy, :order => 'position ASC'
  
  #validates :title, :presence => true
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
        questions.create :question => field.question, :answer => answer, :position => field.position
      end
      self.save
    end
  end
  
  def update_answers(answers)
    if !answers.blank?
      self.questions.each do |question|
        question.answer = answers[question.position.to_s]
        question.save
      end
    end
  end
  
end
