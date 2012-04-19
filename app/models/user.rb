class User < ActiveRecord::Base
  # name:string
  # email:string
  # privilege:string
  # password:string
  # location:string  
  # active:boolean
  
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  
  has_many :user_tickets
  has_many :tickets, :through => :user_tickets, :uniq => true
  has_many :user_service_areas
  has_many :service_areas, :through => :user_service_areas, :uniq => true
  
  validates :name, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :privilege, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates_inclusion_of :privilege, :in => ["user", "service provider", "admin"]
  
  # At some point privilege should be removed from this.
  # That will require changing how we create and update users.
  attr_accessible :name, :password, :location, :email, :privilege
  
  def admin?
    privilege == "admin"
  end
  
  def service_provider?
    privilege == "service provider"
  end
  
  def user?
    privilege == "user"
  end
  
  def inactive?
    active == false
  end
  
  def list_service_areas
    list_sa = ""  
    self.service_areas.each do |sa|
      list_sa += sa.name + " "
    end
    list_sa
  end
  
  def add_service_area_by_id(id)
    sa = self.user_service_areas.find_by_service_area_id(id)    
    if sa.nil?
      user_service_areas.build(:service_area_id => id)    
    end
  end
  
  def remove_service_area_by_id(id)
    sa = self.user_service_areas.find_by_service_area_id(id)    
    if sa
      sa.destroy
    end
  end  
  
  def self.next_provider
    User.where(:privilege => "service provider").limit(1).first
  end
  
end
