class Location < ActiveRecord::Base
  # name:string
  # address:string
  
  has_many :rules, :dependent => :destroy
end
