class ServiceArea < ActiveRecord::Base
  # name:string
  # description:text
  # active:boolean
  
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  
  has_many :tickets
  has_many :user_service_areas
  has_many :users, :through => :user_service_areas, :uniq => true
  
  validates :name, :presence => true, :uniqueness => true
  
  def inactive?
    active == false
  end
  
end
