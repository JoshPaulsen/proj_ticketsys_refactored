class User < ActiveRecord::Base
  # name:string
  # email:string
  # privilege:string
  # password:string
  # location:string
  # department:string
  
  has_many :issues
  has_many :tickets, :through => :issues, :uniq => true
  
  validates :name, :presence => true, :uniqueness => true
  validates :password, :presence => true
  validates :privilege, :presence => true
  validates :email, :presence => true, :uniqueness => true
  validates_inclusion_of :privilege, :in => ["user", "service provider", "admin"]
  
  # At some point privilege and possibly department should be removed from this.
  # That will require changing how we create and update users.
  attr_accessible :name, :password, :location, :email, :department, :privilege  
  
  def admin?
    privilege == "admin"
  end
  
  def service_provider?
    privilege == "service provider"
  end
  
  def user?
    privilege == "user"
  end
  
  # Currently this just returns the first service provider for a department
  # It will need to be fixed to return the appropriate service provider possibly
  # Using some sort of round robin scheduling.
  def self.next_provider(depart)
    User.where(:privilege => "service provider", :department => depart).limit(1).first
  end
  
end
