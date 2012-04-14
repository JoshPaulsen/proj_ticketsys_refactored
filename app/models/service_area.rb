class ServiceArea < ActiveRecord::Base
  # name:string
  # description:text
  
  has_many :tickets
  validates :name, :presence => true, :uniqueness => true
  
end
