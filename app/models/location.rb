class Location < ActiveRecord::Base
  # name:string
  # address:string
  # active:boolean
  default_scope :order => 'id ASC'
  
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  
  #has_many :tickets
  has_many :rules, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true
  
  def inactive?
    active == false
  end
end
