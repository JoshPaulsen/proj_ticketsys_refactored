class User < ActiveRecord::Base
  # name:string
  # email:string
  # privilege:string
  # password:string
  # location:string
  
  has_many :issues
  has_many :tickets, :through => :issues, :uniq => true
  
  validates :name, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :privilege, :presence => true
  
  attr_accessible :name, :password, :location, :email, :privilege
  
  
  def admin?
    privilege == "admin"
  end
  
  def service_provider?
    privilege == "service_provider"
  end
  
  def user?
    privilege == "user"
  end
  
  def self.next_provider    
   provider = User.where(:privilege => "service_provider").limit(1).first   
   provider
  end
  
end
