class User < ActiveRecord::Base
  # name:string
  # email:string
  # privilege:string  
  # active:boolean
  # encrypted_password:string
  # salt:string
  # first_name:string
  # last_name:string
  
  
  default_scope :order => 'last_name ASC'
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  
  has_many :user_tickets
  has_many :tickets, :through => :user_tickets, :uniq => true
  has_many :user_service_areas
  has_many :service_areas, :through => :user_service_areas, :uniq => true
  
  #validates :name, :uniqueness => true
  validates :first_name, :presence => true
  validates :last_name, :presence => true
  validates :encrypted_password, :presence => true
  validates :salt, :presence => true
  validates :privilege, :presence => true
  validates :email, :presence => true #, :uniqueness => true
  validates_inclusion_of :privilege, :in => ["user", "service provider", "admin"]
  
  # At some point privilege should be removed from this.
  # That will require changing how we create and update users.
  attr_accessible :email, :privilege, :first_name, :last_name, :name
  
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
  
  def status   
    if !verified?
      "unverified"
    elsif inactive?
      "inactive"
    else
      "active"
    end
  end
  
  def full_name
    first_name + " " + last_name
  end
  
  def last_first
    last_name + ", " + first_name
  end
  
  def last_first_initial
    last_name + ", " + first_name[0]
  end  
  
  def first_initial_last
    first_name[0] + ". " + last_name
  end
  
  def self.authenticate(email, submitted_password)
    user = find_by_email email
    if !user
      return nil
    end
    
    if user.has_password?(submitted_password)
      return user
    end
  end
  
  def self.authenticate_with_salt(id, salt)
    user = User.find_by_id id
    if user and user.salt == salt
      user
    else
      nil
    end
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
  
  def service_area_ids
    service_areas.collect do |sa|
      sa.id
    end
  end
  
  def accessible_tickets
    if admin?
      Ticket.scoped
    elsif service_provider?
      if service_areas.blank?
        tickets
      else        
        sa_ids = get_str(service_area_ids)
        Ticket.joins(:user_tickets).where("user_tickets.user_id = ? OR service_area_id IN  #{sa_ids}", self.id).uniq 
      end
    else
      tickets
    end
  end
  
  def has_password?(password)
    encrypted_password == encrypt(password)
  end
  
  
 
 
  def set_encrypted_password(password)
    self.salt = make_salt(password) if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  private
  
  def encrypt(password)
    secure_hash("#{salt}--#{password}")
  end
  
  def make_salt(password)
    secure_hash("#{Time.now.utc}--#{password}")
  end
  
  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
  def get_str(list)
    s = list.to_s
    s = s.sub("[","(")
    s = s.sub("]",")")
  end
  
end
