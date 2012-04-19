class Location < ActiveRecord::Base
  # name:string
  # address:string
  # active:boolean
  
  scope :active, where(:active => true)
  scope :inactive, where(:active => false)
  
  has_many :rules, :dependent => :destroy
  validates :name, :presence => true, :uniqueness => true
  
  def inactive?
    active == false
  end
end
